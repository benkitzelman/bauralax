class Game
  @assets = [
    # "sprites.json"
    # "sprites.png"
    "/assets/images/star.png"
    "/assets/images/ship.png"
    "/assets/images/ship3.png"
    "/assets/images/shieldFlare.png"
    "/assets/images/planet0.png"
    "/assets/images/planet1.png"

    "/assets/audio/ship_explosion.mp3"
  ]

  @start = ->
    @started ?= new $.Deferred
    return if @started.state() is 'resolved'

    # $.getScript 'http://cdn.html5quintus.com/v0.2.0/quintus-all.js', =>
    console.log 'starting game...'
    @instance = new Game()
    window.G  = @instance

  constructor: ->
    @Q = window.Q

    @Q.gravityY   = 0
    @Q.gravityX   = 0
    # @Q.debug      = true
    @Q.clearColor = "#000"

    @loadAssets()
    @playerTeam = Team.GREEN

  loadAssets: ->
    @Q.load Game.assets.join(', '), =>
      # Finally, call stageScene to run the game
      @Q.stageScene "level2"
      Game.started.resolveWith this
