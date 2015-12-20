Q.Sprite.extend 'Explosion',
  init: (p) ->
    @_super Q._extend
        asset: '/assets/images/ship.png'
        type: Q.SPRITE_NONE
        opacity: .5
        opacityRate: -.03
        w: 5
        z: 5
        ttl: 200
      , p

    @add('ttl')

  draw: (ctx) ->
    ctx.save()

    ctx.fillStyle = "rgba(245, 185, 62, 0.75)"
    ctx.beginPath()
    ctx.arc 0, 0, @p.w * 3, 0, 180
    ctx.fill()
    ctx.restore()

  step: (dt) ->
    if @p.opacity >= 0
      @p.opacity += @p.opacityRate
    else
      @destroy()

  draw: (ctx) ->
    ctx.globalCompositeOperation = 'lighter'
    @_super(ctx)


