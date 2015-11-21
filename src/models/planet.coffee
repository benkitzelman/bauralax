Q.Sprite.extend "Planet",
  init: (p) ->
    scale  = (Math.ceil(Math.random() * 10) / 10)

    @_super Q._extend
      asset : @randomAsset()
      scale : scale
      type  : Q.SPRITE_NONE
    , p

    @add '2d'

    # Write event handlers to respond hook into behaviors.
    # hit.sprite is called everytime the player collides with a sprite
    @on "hit.sprite", @onCollision

  randomAsset: ->
    assets = [0..1].map (i) -> "/assets/images/planet#{i}.png"
    assets[ Math.floor(Math.random() * 10) % (assets.length) ]

  teamColor: ->
    switch @p.team
      when "RED"   then "rgba(255,0,0,0.25)"
      when "GREEN" then "rgba(0,255,0,0.25)"
      when "BLUE"  then "rgba(0,0,255,0.25)"
      else "rgba(45,45,45,0.5)"

  draw: (ctx) ->
    ctx.save()
    ctx.globalCompositeOperation = 'lighter'
    ctx.drawImage @asset(), 0, 0, @asset().width, @asset().height

    ctx.beginPath()
    ctx.fillStyle = @teamColor()
    ctx.arc(@asset().width / 2, @asset().height / 2, @asset().width / 2, 0, 180)
    ctx.fill()
    ctx.restore()

  onCollision: (collision) =>
    console.log 'HIT'
    # Q.stageScene "endGame",1, label: "You Lose!"
    # Remove the player to prevent them from moving
    # @destroy()
