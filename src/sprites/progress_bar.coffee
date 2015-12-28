Q.Sprite.extend 'ProgressBar',
  init: (p) ->
    @_super _.defaults p,
      asset       : '/assets/images/star.png'
      type        : Q.SPRITE_UI
      w           : 30
      h           : 5
      strokeWidth : 2
      opacity     : 1
      opacityRate : -.01
      color       : '#FFFF00'

  set: (progress, color) ->
    @p.progress = progress
    @p.color    = color
    @p.opacity  = 1

  step: (dt) ->
    if @p.opacity >= 0
      @p.opacity = _.max [ @p.opacity + @p.opacityRate, 0 ]

  draw: (ctx) ->
    ctx.save()
    ctx.beginPath()

    # box
    ctx.fillStyle = "rgba(255,255,255,0.5)"
    ctx.fillRect 0, 0, @p.w, @p.h

    # progress fill
    offset = @p.strokeWidth - 1
    width  = ( @p.w - @p.strokeWidth ) * ( @p.progress or 0 )
    ctx.fillStyle = @p.color
    ctx.fillRect offset, offset, width, @p.h - @p.strokeWidth

    ctx.closePath()
    ctx.restore()