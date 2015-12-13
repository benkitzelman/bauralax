Q.Sprite.extend "Planet",
  init: (p) ->
    scale  = _.max [0.4, (Math.ceil(Math.random() * 10) / 10)]

    @_super Q._extend
      sensor    : true
      asset     : @randomAsset()
      scale     : scale
      team      : Team.NONE
      type      : Q.SPRITE_DEFAULT
      buildRate : 500
    , p

    @add '2d'
    @add 'shipBuilder'

    # Write event handlers to respond hook into behaviors.
    # hit.sprite is called everytime the player collides with a sprite
    # @on "hit.sprite", @onCollision

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
