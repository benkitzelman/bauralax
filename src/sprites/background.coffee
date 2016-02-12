Q.Sprite.extend 'Background',
  init: (p) ->
    @_super p,
      asset   : 'planets/nebula/blue.png'
      x       : 0
      y       : 0
      w       : Q.width
      h       : Q.height
      type    : Q.SPRITE_PARTICLE
      opacity : 0.15
      scale   : 2

    @p.x = @asset().width * @p.scale / 2 * -1
    @p.y = @asset().height / 2 * -1

  aspectRatio: ->
    @asset().width / @asset().height

  draw: (ctx) ->
    height = @asset().height
    width  = @p.w * @aspectRatio()

    ctx.save()

    ctx.globalAlpha = @p.opacity
    ctx.drawImage @asset(), 0, 0, @asset().width, @asset().height, 0, 0, width, height

    ctx.restore()


