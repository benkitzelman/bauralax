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

    @playerTeam.on 'planet-won',  @, 'winLoseOrContinue'
    @playerTeam.on 'planet-lost', @, 'winLoseOrContinue'

  stages: ->
    [
      StageDebug
      StageOne
      StageTwo
    ]

  isLastStage: ->
    @stages()[ @currentLevelIdx + 1 ]?

  nextStage: ->
    @currentLevelIdx ?= 0
    @stages()[ ++@currentLevelIdx ]?.load()

  currentStage: ->
    @stages()[ @currentLevelIdx ]?.instance

  winLoseOrContinue: ->
    planets = ->
      Q.select('Planet')?.items

    hasWon = ->
      _.all planets(), (p) -> p.teamResource.belongsToPlayer()

    hasLost = ->
      _.all planets(), (p) -> not p.teamResource.belongsToPlayer()

    return @currentStage().transitionTo( StageWonGame  ) if hasWon()
    return @currentStage().transitionTo( StageLostGame ) if hasLost()
    # continue

  loadAssets: ->
    _.invoke @stages(), 'register'

    @Q.load Game.assets.join(', '), =>
      # Finally, call stageScene to run the game
      @startingStage()
      Game.started.resolveWith this

  startingStage: ->
    Q.clearStages()
    _.first( @stages() ).load()

  replayLastStage: ->
    @stages()[ @currentLevelIdx ].load()
