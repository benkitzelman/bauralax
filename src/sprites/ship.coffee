Q.Sprite.extend "Ship",
  init: (p) ->
    @_super _.defaults p,
      type         : Q.SPRITE_DEFAULT
      sensor       : true
      team         : Team.NONE
      asset        : '/assets/images/ship.png' # HACK - this should be ignored
      width        : 10
      height       : 10
      maxSpeed     : 30
      acceleration : 10
      angle        : 90
      scale        : 0.75
      opacity      : 0.5
      lastX        : p.x
      lastY        : p.y
      path         : new Path

    if @p.path and not (@p.path instanceof Path)
      @p.path = new Path(@p.path)

    @add '2d'

    # Write event handlers to respond hook into behaviors.
    # hit.sprite is called everytime the player collides with a sprite
    @on "hit.sprite", @, 'onCollision'

  draw: (ctx) ->
    @_super(ctx)
    ctx.globalCompositeOperation = 'lighter'
    ctx.save()

    ctx.beginPath()
    ctx.fillStyle = @p.team.color(0.75)
    # ctx.arc(0, 0, @asset().width / 2, 0, 180)
    ctx.arc(0, 0, @p.width / 2, 0, 180)
    ctx.fill()

    ctx.restore()

  currentTarget: ->
    @p.path.current()

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

  isTeammate: (entity) ->
    entity.p.team is @p.team

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
      type: 'hit'
      x: x + ( Q.offsetX( newAngle, dist ) )
      y: y + ( Q.offsetY( newAngle, dist ) )

  onCollision: (collision) ->
    if collision.obj.isA("Ship")
      return @destroy() unless @isTeammate( collision.obj )


