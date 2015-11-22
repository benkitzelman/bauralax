Q.Sprite.extend "Ship",
  init: (p) ->
    @_super _.defaults p,
      type         : Q.SPRITE_NONE
      team         : Team.NONE
      asset        : '/assets/images/star.png' # HACK - this should be ignored
      maxSpeed     : 80
      acceleration : 50
      angle        : 90
      scale        : 0.75
      opacity      : 0.5
      lastX        : p.x
      lastY        : p.y

    @add '2d'

    # Write event handlers to respond hook into behaviors.
    # hit.sprite is called everytime the player collides with a sprite
    @on "hit.sprite", @onCollision

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

    if @p.targetXY
      x: @p.targetXY[0]
      y: @p.targetXY[1]

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

    limited speed

  step: (dt) ->
    return unless target = @targetCoords()

    targetAngle = Q.angle(@p.x, @p.y, target.x, target.y)
    xSpeed      = Q.offsetX(targetAngle, @p.acceleration) * dt * @p.acceleration
    ySpeed      = Q.offsetY(targetAngle, @p.acceleration) * dt * @p.acceleration

    mod =
      x: if targetAngle >= 180 then -1 else 1
      y: if targetAngle >= 90 or targetAngle <= 270 then -1 else 1

    @p.angle = targetAngle
    @p.vx    = @applyInertia( xSpeed ) * mod.x
    @p.vy    = @applyInertia( ySpeed ) * mod.y

  onCollision: (collision) =>
    console.log 'HIT'
    # Q.stageScene "endGame",1, label: "You Lose!"
    # Remove the player to prevent them from moving
    # @destroy()
