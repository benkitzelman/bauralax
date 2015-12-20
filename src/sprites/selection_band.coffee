Q.Sprite.extend 'SelectionBand',

  init: (p) ->
    @_super _.defaults p,
      asset  : '/assets/images/star.png'
      type   : Q.SPRITE_NONE
      radius : 2

  draw: (ctx) ->
    ctx.globalCompositeOperation = 'lighter'
    ctx.save()

    ctx.beginPath()
    ctx.fillStyle = "rgba(255, 255, 255, 0.3)"
    ctx.arc(0, 0, @p.radius, 0, 180)
    ctx.fill()

    ctx.restore()

