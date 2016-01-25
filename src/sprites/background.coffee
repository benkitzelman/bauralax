Q.Sprite.extend 'Background',
  init: (p) ->
    @_super p,
      asset: 'planets/nebula/blue.png'
      w: Q.width
      h: Q.height
      type: Q.SPRITE_PARTICLE
      opacity: 0.15
      scale: 4

  draw: (ctx) ->
    ctx.save()

    ctx.globalAlpha = @p.opacity

    x = @asset().width / 2 * -1
    y = @asset().height / 2 * -1

    ctx.drawImage @asset(), x, y, @p.w, @p.h

    ctx.restore()


