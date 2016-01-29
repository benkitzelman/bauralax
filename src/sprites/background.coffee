Q.Sprite.extend 'Background',
  init: (p) ->
    @_super p,
      asset   : 'planets/nebula/blue.png'
      x       : 0
      y       : 0
      w       : Q.width
      h       : Q.height
      type    : Q.SPRITE_PARTICLE
      opacity : 0.3
      scale   : 4
    @p.x = @asset().width * @p.scale / 2 * -1
    @p.y = @asset().height / 2 * -1

  draw: (ctx) ->
    ctx.save()

    ctx.globalAlpha = @p.opacity
    ctx.drawImage @asset(), 0, 0, @p.w, @p.h

    ctx.restore()


