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

  @unitCap: 450

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

    @currentLevelIdx = 0
    @playerTeam      = Team.GREEN

    @playerTeam.on 'planet-won',  @, 'nextStage'
    @playerTeam.on 'planet-lost', @, 'nextStage'

  stages: ->
    [
      StageOne
      StageTwo
      # 'level2'
      # 'endGame'
    ]

  nextStage: ->
    @currentLevelIdx ?= 0

    planets = ->
      Q.select('Planet')?.items

    hasWon = ->
      _.all planets(), (p) -> p.teamResource.belongsToPlayer()

    hasLost = ->
      not _.any planets(), (p) -> p.teamResource.belongsToPlayer()

    return @stages()[ ++@currentLevelIdx ]?.load() if hasWon()
    return @stages()[ @currentLevelIdx ]?.load() if hasLost()

  loadAssets: ->
    _.invoke @stages(), 'register'

    @Q.load Game.assets.join(', '), =>
      # Finally, call stageScene to run the game
      _.first( @stages() ).load()
      Game.started.resolveWith this
