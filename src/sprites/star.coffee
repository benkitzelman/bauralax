Q.Sprite.extend 'Star',
  init: (p) ->
    @_super p,
      x: Math.random() * Q.width
      y: Math.random() * Q.height
      scale: Math.max Math.random(), .3
      w: 5
      h: 5
      type: Q.SPRITE_PARTICLE

    @p.starColor = if Q.random(0, 10) is 1 # color 10% of stars
      @randomColor()
    else
      Q.colorString( [ 255,255,255, 0.5 ] )

  randomColor: ->
    colors = [
      [ 245, 85,  10,  0.75 ]
      [ 200, 200, 10,  0.75 ]
      [ 116, 206, 245, 0.75 ]
    ].map Q.colorString

    colors[ Q.random(0, colors.length - 1) ]


  draw: (ctx, args...) ->
    return unless @p.starColor

    ctx.save()
    ctx.globalCompositeOperation = 'lighter'

    ctx.beginPath()
    radius = @p.w / 2
    gradient = ctx.createRadialGradient 0, 0, radius, 0, 0, 1
    gradient.addColorStop 0, "transparent"
    gradient.addColorStop 1, @p.starColor

    ctx.fillStyle = gradient

    # ctx.fillStyle = @p.starColor
    ctx.arc 0, 0, @p.w, 0, 180
    ctx.fill()

    ctx.restore()