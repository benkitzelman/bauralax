class Game
  @assets = [
    # "sprites.json"
    # "sprites.png"
    "star.png"
    "ship.png"
    "ship3.png"
    "shieldFlare.png"
    "planet0.png"
    "planet1.png"
    "earth.jpg"
    "planet_sheet_0.png"
    "planet_sheet_0.json"

    "ship_explosion.mp3"
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
      @Q.compileSheets("planet_sheet_0.png", "planet_sheet_0.json")
      @configureAnimations()
      # Finally, call stageScene to run the game
      @startingStage()
      Game.started.resolveWith this

  configureAnimations: ->
    @Q.animations 'planet0',
      rotate:
        frames: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        rate: 1/15

  startingStage: ->
    Q.clearStages()
    _.first( @stages() ).load()

  replayLastStage: ->
    Q.clearStages()
    @stages()[ @currentLevelIdx ].load()
