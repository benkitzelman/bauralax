Q.Sprite.extend "Planet",
  init: (p) ->
    scale  = _.max [0.4, (Math.ceil(Math.random() * 10) / 10)]

    @_super Q._extend
      sensor    : true
      asset     : @randomAsset()
      scale     : scale
      team      : Team.NONE
      type      : Q.SPRITE_UI
      buildRate : 2000
    , p

    @add '2d'
    @add 'shipBuilder'
    @add 'shipAbsorber'
    @on 'touch', @, 'onTouch'

  onTouch: (args...) ->
    console.log 'planet touch', args...

  randomAsset: ->
    assets = [0..1].map (i) -> "/assets/images/planet#{i}.png"
    assets[ Math.floor(Math.random() * 10) % (assets.length) ]

  draw: (ctx) ->
    @_super(ctx)

    ctx.save()
    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()
    ctx.fillStyle = @p.team.color(0.25)
    ctx.arc(0, 0, @asset().width / 2, 0, 180)
    ctx.fill()
    ctx.restore()