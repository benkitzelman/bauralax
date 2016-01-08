Q.Sprite.extend 'Marker',

  init: (p) ->
    @_super _.defaults p,
      asset : 'star.png'
      type  : Q.SPRITE_NONE
      gap   : 1

  draw: (ctx) ->
    ctx.beginPath()
    ctx.strokeStyle = "rgba(255,255,0,1)"
    ctx.lineWidth = 2

    x = @asset().width / 2
    y = @asset().height / 2

    # vertical
    ctx.moveTo 0, 0 - @p.gap
    ctx.lineTo 0, y * -1

    ctx.moveTo 0, @p.gap
    ctx.lineTo 0, y

    # horizontal
    ctx.moveTo 0 - @p.gap, 0
    ctx.lineTo x * -1, 0

    ctx.moveTo @p.gap, 0
    ctx.lineTo x, 0

    ctx.stroke()
