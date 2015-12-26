class Game
  @assets = [
    # "sprites.json"
    # "sprites.png"
    "star.png"
    "ship.png"
    "shieldFlare.png"
    "planet0.png"
    "planet1.png"
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
    @playerTeam = Team.RED

  loadAssets: ->
    assetList = Game.assets.map( (fileName) -> "/assets/images/#{fileName}" ).join(', ')
    @Q.load assetList, =>
      # Finally, call stageScene to run the game
      @Q.stageScene "level1"
      Game.started.resolveWith this
