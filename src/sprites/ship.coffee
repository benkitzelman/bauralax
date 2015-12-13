Q.Sprite.extend "Ship",
  init: (p) ->
    @_super _.defaults p,
      type         : Q.SPRITE_DEFAULT
      sensor       : true
      team         : Team.NONE
      asset        : '/assets/images/star.png' # HACK - this should be ignored
      maxSpeed     : 30
      acceleration : 10
      angle        : 90
      scale        : 0.75
      opacity      : 0.5
      lastX        : p.x
      lastY        : p.y

    @add '2d'

    # Write event handlers to respond hook into behaviors.
    # hit.sprite is called everytime the player collides with a sprite
    # @on "hit.sprite", @onCollision
    @on "sensor", @, 'onCollision'
    @on "hit.sprite", @, 'onCollision'

  draw: (ctx) ->
    ctx.globalCompositeOperation = 'lighter'
    @_super(ctx)

    ctx.save()

    ctx.beginPath()
    ctx.fillStyle = @p.team.color(0.75)
    ctx.arc(0, 0, @asset().width / 2, 0, 180)
    ctx.fill()

    ctx.restore()

  targetCoords: ->
    if @p.target?
      _.pick @p.target.p, 'x', 'y', 'vx', 'vy'
    else
      @p.targetXY

  stop: ->
    @p.vx = @p.vy = 0

  applyInertia: (speed) ->
    shouldChange = => true

    shouldAccelerate = =>
      speed < @p.maxSpeed and shouldChange()

    shouldDecelerate = =>
      speed >= @p.maxSpeed and shouldChange()

    limited = (speed) =>
      _.min [ @p.maxSpeed, speed ]

    # limited speed
    speed

  isAt: ({x, y}) ->
    Math.abs(@p.x - x) < 1 and Math.abs(@p.y - y) < 1

  stop: ->
    @p.vy = @p.vx = 0

  onReachedTarget: (target) ->
    @stop()
    @p.lastX = @p.x
    @p.lastY = @p.y
    delete @p.target
    delete @p.targetXY
    @trigger 'reached-target', item: @, target: target

  moveTo: (coords) ->
    @p.targetXY = coords

  step: (dt) ->
    return unless target = @targetCoords()
    return @onReachedTarget( target ) if @isAt(target)

    maxStepDistance = @p.maxSpeed
    targetAngle  = Q.angle(@p.x, @p.y, target.x, target.y) # angle
    tripDistance = Q.distance(@p.x, @p.y, target.x, target.y) # trip hypotenuse
    stepDistance = _.min [ tripDistance, maxStepDistance ] # step hypotenuse

    xDistance    = Q.offsetX(targetAngle, stepDistance)
    yDistance    = Q.offsetY(targetAngle, stepDistance)

    axis =
      x: if targetAngle >= 180 then 1 else -1
      y: if targetAngle >= 90 or targetAngle <= 270 then -1 else 1

    @p.vx = xDistance * axis.x
    @p.vy = yDistance * axis.y

  onCollision: (collision) ->
    console.log 'ship'
    # Q.stageScene "endGame",1, label: "You Lose!"
    # Remove the player to prevent them from moving
    # @destroy()
