MAX_HIT_POINTS = 50

Q.Sprite.extend "Ship",
  init: (p) ->
    @_super _.defaults p,
      type         : Q.SPRITE_DEFAULT
      sensor       : true
      team         : Team.NONE
      collisions   : false
      asset        : 'ship.png'
      radius       : 1
      hitPoints    : 1
      maxSpeed     : 25
      acceleration : 8
      angle        : 90
      scale        : 0.75
      opacity      : 1
      lastX        : p.x
      isSelected   : false
      lastY        : p.y
      path         : new Path

    @p.path = new Path(@p.path) unless (@p.path instanceof Path)

    @add '2d'
    @add 'teamResource'
    @add 'absorbable'

    @on "hit.sprite", @, 'onCollision'

  shipRadius: ->
    @p.radius * @p.hitPoints

  draw: (ctx) ->
    @drawShip ctx
    @drawTeamColour ctx
    @drawHaze ctx
    @drawSelectionMarker( ctx ) if @p.isSelected

  drawShip: (ctx) ->
    ctx.save()
    ctx.globalCompositeOperation = 'source-over'
    ctx.beginPath()
    ctx.fillStyle = "white"
    ctx.arc 0, 0, @shipRadius(), 0, 180
    ctx.fill()
    ctx.closePath()
    ctx.restore()

  drawTeamColour: (ctx) ->
    ctx.save()
    ctx.globalCompositeOperation = 'lighter'

    ctx.beginPath()

    ctx.fillStyle = @teamResource.val().color 0.15
    ctx.arc 0, 0, @shipRadius(), 0, 180
    ctx.fill()

    ctx.restore()

  drawHaze: (ctx) ->
    alpha       = 0.07 * @p.hitPoints
    outerRadius = @shipRadius() + _.max [ 20, @p.hitPoints * 3 ]

    ctx.save()
    ctx.globalCompositeOperation = 'lighter'

    ctx.beginPath()

    gradient = ctx.createRadialGradient 0, 0, outerRadius, 0, 0, @shipRadius()
    gradient.addColorStop 0, "transparent"
    gradient.addColorStop 1, @teamResource.val().color(alpha)

    ctx.fillStyle = gradient
    ctx.arc 0, 0, outerRadius, 0, 180
    ctx.fill()

    ctx.restore()

  drawSelectionMarker: (ctx) ->
    radius = @shipRadius() + 4

    ctx.save()

    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()
    ctx.arc 0, 0, radius, 0, 180
    ctx.lineWidth = 2
    ctx.strokeStyle = "rgba(255, 255, 255, 0.8)"
    ctx.stroke()

    ctx.restore()

  currentTarget: ->
    @p.path.current()

  hasTargeted: (entity) ->
    return false unless t = @currentTarget()
    t.obj is entity or entity.isInBounds( t.coords() )

  stop: ->
    @p.vx = @p.vy = 0

  isAt: (target) ->
    { x, y } = target.coords()
    Math.abs(@p.x - x) < 1 and Math.abs(@p.y - y) < 1

  stop: ->
    @p.path.clear()
    @p.vy = @p.vx = 0

  onReachedTarget: (target) ->
    @p.lastX = @p.x
    @p.lastY = @p.y
    @stop() unless @p.path.moveNext()
    @trigger 'reached-target', item: @, target: target
    @moveAround()

  moveTo: (coords) ->
    return unless coords
    @p.path.set [ coords ]

  moveNext: (coords) ->
    @p.path.add coords

  select: ->
    @p.isSelected = true

  isSelected: ->
    @p.isSelected

  deselect: ->
    delete @p.isSelected

  step: (dt) ->
    return unless target = @currentTarget()
    return @onReachedTarget( target ) if @isAt( target )

    maxStepDistance = @p.maxSpeed
    targetAngle     = Q.angle(@p.x, @p.y, target.coords().x, target.coords().y) # angle
    tripDistance    = Q.distance(@p.x, @p.y, target.coords().x, target.coords().y) # trip hypotenuse
    stepDistance    = _.min [ tripDistance, maxStepDistance ] # step hypotenuse

    xDistance       = Q.offsetX(targetAngle, stepDistance)
    yDistance       = Q.offsetY(targetAngle, stepDistance)

    axis =
      x: if targetAngle >= 180 then 1 else -1
      y: if targetAngle >= 90 or targetAngle <= 270 then -1 else 1

    @p.angle = targetAngle
    @p.vx    = xDistance * Q.axis(targetAngle).x
    @p.vy    = yDistance * Q.axis(targetAngle).y

  moveAround: ->
    { x, y, path, angle } = @p

    newAngle = Q.random 0, 360
    dist     = Q.random 2, 8 # hypot
    @moveNext
      type: Target.AIMLESS
      x: x + ( Q.offsetX( newAngle, dist ) )
      y: y + ( Q.offsetY( newAngle, dist ) )

  isIdle: ->
    _.all @p.path.items, (t) -> t.type() is Target.AIMLESS

  absorb: ->
    @explode()

  damageWith: (sprite) ->
    hp      = @p.hitPoints
    enemyHp = sprite.p.hitPoints

    @p.hitPoints       = _.max [ 0, hp - enemyHp ]
    sprite.p.hitPoints = _.max [ 0, enemyHp - hp ]

    if @p.hitPoints is 0
      @explode sprite.teamResource?().val().color(0.75)

    if sprite.p.hitPoints is 0
      sprite.destroy()

  explode: (color)->
    @stage.insert new Q.Explosion
      x     : @p.x
      y     : @p.y
      vx    : @p.vx
      vy    : @p.vy
      radius: @asset().width * 3
      color : color or @teamResource.val().color(0.75)

    Q.audio.play 'ship_explosion.mp3'
    @destroy()

  absorbFriend: ( friend ) ->
    @p.absorptionValue = @p.hitPoints = _.min [ @p.hitPoints + friend.p.hitPoints, MAX_HIT_POINTS ]
    friend.destroy()

  wantsToGrow: ->
    chances = =>
      Math.pow 1000, @p.hitPoints

    return false if @p.hitPoints >= MAX_HIT_POINTS
    Q.random(0, chances()) is 1

  onCollision: (collision) ->
    return if collision.obj?.isDestroyed
    return unless @teamResource.isTeamResource( collision.obj )

    isEnemyShip = =>
      collision.obj.isA("Ship") and not @teamResource.isTeammate( collision.obj )

    isFriendlyShip = =>
      collision.obj.isA("Ship") and @teamResource.isTeammate( collision.obj )

    canAbsorb = =>
      isFriendlyShip() and @wantsToGrow()

    return @damageWith( collision.obj )   if isEnemyShip()
    return @absorbFriend( collision.obj ) if canAbsorb()

