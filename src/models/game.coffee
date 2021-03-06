class Game
  @assets = [
    "ship.png"
    "shieldFlare.png"

    "planets/nebula/blue.png"
    # "planets/nebula/green.png"

    "planets/red/0.png"
    "planets/red/1.png"
    "planets/green/0.png"
    "planets/green/1.png"
    "planets/blue/0.png"
    "planets/blue/1.png"
    "planets/none/0.png"
    "planets/none/1.png"

    "planets/red/nebula_0.png"
    "planets/green/nebula_0.png"
    "planets/blue/nebula_0.png"

    "planets/red/nebula_1.png"
    "planets/green/nebula_1.png"
    "planets/blue/nebula_1.png"

    "planets/planet0.png"
    "planets/planet1.png"
    "planets/planet_sheet_0.png"
    "planets/planet_sheet_0.json"

    "ship_yard/blue.png"
    "ship_yard/red.png"
    "ship_yard/green.png"

    "ship_explosion.mp3"
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
    @Q.clearColor = "#000"

    @loadAssets()

    @currentLevelIdx = 0
    @playerTeam      = Team.GREEN

    @playerTeam.on 'planet-won',  @, 'winLoseOrContinue'
    @playerTeam.on 'planet-lost', @, 'winLoseOrContinue'

  stages: ->
    [
      StageOne
      StageTwo
      StageThree
      StageFour
      StageDebug
    ]

  isLastStage: ->
    !@stages()[ @currentLevelIdx + 1 ]

  nextStage: ->
    @currentLevelIdx ?= 0
    @stages()[ ++@currentLevelIdx ]?.load()

  currentStage: ->
    @stages()[ @currentLevelIdx ]?.instance

  winLoseOrContinue: ->
    planets = ->
      Q.select('Planet')?.items

    hasWon = ->
      _.all planets(), (p) -> p.teamResource.belongsToPlayer() or p.teamResource.val() is Team.NONE

    hasLost = ->
      _.all planets(), (p) -> not p.teamResource.belongsToPlayer()

    return @currentStage().transitionTo( StageWonGame  ) if hasWon()
    return @currentStage().transitionTo( StageLostGame ) if hasLost()

  loadAssets: ->
    onLoaded = =>
      @Q.compileSheets("planet_sheet_0.png", "planet_sheet_0.json")
      @mainMenu()
      Game.started.resolveWith this

    showGameCanvas = ->
      _.delay (-> $( '#game' ).removeClass 'hide'), 1000
    #--

    _.invoke @stages(), 'register'

    allAssets = Game.assets.join ', '
    progress  = ProgressBar.instance()
    progress.whenAssetsLoad.done showGameCanvas

    @Q.load allAssets, onLoaded, progressCallback: progress.update

  viewport: ->
    @currentStage()?.QStage.viewport

  loadStage: (stage) ->
    @currentLevelIdx = _.indexOf @stages(), stage
    stage.load()

  mainMenu: ->
    LevelSelect.load()

  startingStage: ->
    @loadStage _.first( @stages() )

  replayLastStage: ->
    @loadStage @stages()[ @currentLevelIdx ]
