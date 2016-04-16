class Hud extends HtmlComponent
  @instance = ->
    @_bar ?= new Hud
    @_bar

  elements:
    '#level-hud'        : 'el'
    '#level-hud .pause' : 'pauseBtn'
    '#level-hud .play'  : 'playBtn'

  events:
    'click #level-hud .replay'    : 'onReplayClicked'
    'click #level-hud .pause'     : 'onPauseClicked'
    'click #level-hud .play'      : 'onPlayClicked'
    'click #level-hud .main-menu' : 'onMainMenuClicked'

  constructor: ->
    super
    @playBtn.hide()

  onReplayClicked: (args...) ->
    return if @isHidden()
    Game.instance.replayLastStage()

  onPauseClicked: ->
    return if @isHidden()

    @playBtn.show()
    @pauseBtn.hide()
    Q.pauseGame()

  onPlayClicked: ->
    return if @isHidden()

    @playBtn.hide()
    @pauseBtn.show()
    Q.unpauseGame()

  onMainMenuClicked: ->
    return if @isHidden()
    Game.instance.mainMenu()
