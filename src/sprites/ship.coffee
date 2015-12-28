Q.Sprite.extend "Ship",
  init: (p) ->
    @_super _.defaults p,
      type         : Q.SPRITE_DEFAULT
      sensor       : true
      team         : Team.NONE
      asset        : '/assets/images/ship.png'
      maxSpeed     : 30
      acceleration : 10
      angle        : 90
      scale        : 0.75
      opacity      : 1
      lastX        : p.x
      isSelected   : false
      lastY        : p.y
      path         : new Path

    if @p.path and not (@p.path instanceof Path)
      @p.path = new Path(@p.path)

    @add '2d'
    @add 'teamResource'
    @add 'absorbable'

    @on "hit.sprite", @, 'onCollision'

  draw: (ctx) ->
    @_super ctx
    @drawTeamColour ctx
    @drawHaze ctx
    @drawSelectionMarker( ctx ) if @p.isSelected

  drawTeamColour: (ctx) ->
    ctx.save()
    ctx.globalCompositeOperation = 'lighter'

    ctx.beginPath()
    ctx.fillStyle = @teamResource.val().color 0.15
    ctx.arc 0, 0, @p.w / 2, 0, 180
    ctx.fill()

    ctx.restore()

  drawHaze: (ctx) ->

    ctx.save()
    ctx.globalCompositeOperation = 'lighter'

    ctx.beginPath()
    ctx.fillStyle = @teamResource.val().color 0.05
    ctx.arc 0, 0, @p.w + 10, 0, 180
    ctx.fill()

    ctx.restore()

  drawSelectionMarker: (ctx) ->
    radius = 5

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
    @p.vy = @p.vx = 0

  onReachedTarget: (target) ->
    @p.lastX = @p.x
    @p.lastY = @p.y
    @stop() unless @p.path.moveNext()
    @trigger 'reached-target', item: @, target: target
    @moveAround()

  moveTo: (coords) ->
    @p.path.set [ coords ]

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
    path.moveToThenResume
      type: Target.AIMLESS
      x: x + ( Q.offsetX( newAngle, dist ) )
      y: y + ( Q.offsetY( newAngle, dist ) )

  absorb: ->
    @explode()

  explode: (color)->
    @stage.insert new Q.Explosion
      x     : @p.x
      y     : @p.y
      vx    : @p.vx
      vy    : @p.vy
      radius: @asset().width * 3
      color : color or @teamResource.val().color(0.75)

    Q.audio.play '/assets/audio/ship_explosion.mp3'
    @destroy()

  onCollision: (collision) ->
    isEnemyShip = =>
      collision.obj.isA("Ship") and not @teamResource.isTeammate( collision.obj )

    return unless @teamResource.isTeamResource( collision.obj )
    @explode( collision.obj.teamResource?().val().color(0.75) ) if isEnemyShip()
