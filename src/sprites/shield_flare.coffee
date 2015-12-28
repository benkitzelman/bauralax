Q.Sprite.extend 'ShieldFlare',

  init: (p) ->
    @_super Q._extend
        asset       : '/assets/images/shieldFlare.png'
        type        : Q.SPRITE_PARTICLE
        color       : '#FFFFFF'
        opacity     : .5
        opacityRate : -.03
        z           : 5
        ttl         : 200
      , p

    @add 'ttl'

  step: (dt) ->
    if @p.opacity >= 0
      @p.opacity += @p.opacityRate
    else
      @destroy()

  draw: (ctx) ->
    flareWidth = 20
    outer      = @p.radius
    inner      = outer - flareWidth

    ctx.save()
    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()

    ctx.arc 0, 0, @p.radius, 0, 180

    grd = ctx.createRadialGradient 0, 0, @p.radius, 0, 0, inner
    grd.addColorStop 0, @p.color
    grd.addColorStop 1, "transparent"
    ctx.fillStyle = grd
    ctx.fill()

    ctx.closePath()
    ctx.restore()
