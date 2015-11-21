
Q.Sprite.extend "Planet",
  init: (p) ->
    assets = [0..1].map (i) -> "/assets/images/planet#{i}.png"
    asset  = assets[ Math.floor(Math.random() * 10) % (assets.length) ]
    scale  = (Math.ceil(Math.random() * 10) / 10)

    @_super Q._extend
      asset : asset
      scale : scale
      type  : Q.SPRITE_NONE
    , p

    console.log 'HERE'
    @add '2d'

    # Write event handlers to respond hook into behaviors.
    # hit.sprite is called everytime the player collides with a sprite
    @on "hit.sprite", @onCollision

  # draw: (ctx) ->
  #   ctx.save()
  #   # ctx.scale(2,2)
  #   # ctx.beginPath()
  #   ctx.lineWidth = 2
  #   ctx.strokeStyle = "rgba(0,255,0,0.25)"
  #   ctx.lineTo 0, 10
  #   ctx.restore()

  onCollision: (collision) =>
    console.log 'HIT'
    # Q.stageScene "endGame",1, label: "You Lose!"
    # Remove the player to prevent them from moving
    # @destroy()
