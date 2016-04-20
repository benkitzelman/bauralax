class LevelSelector extends HtmlComponent
  elements:
    '#level-selector'              : 'el'
    '#level-selector .levels'      : 'btnContainer'
    '#level-selector .play-btn'    : 'playBtn'
    '#level-selector .levels .btn' : 'levelBtns'

  events:
    'click #level-selector .level-btn' : 'onLevelSelected'
    'click #level-selector .play-btn'  : 'onPlaySelected'

  render: ->
    @btnContainer.html ''
    @renderBtnFor(level) for level in Game.instance?.stages() or []
    @bindEvents()
    @refreshElements()
    this

  renderBtnFor: (level) ->
    readableName = level.name.replace(/stage/i, '')
    @btnContainer.append """
      <div class="level-btn btn" data-name="#{ level.name }">#{ readableName }</div>
    """

  onLevelSelected: (e) ->
    @levelBtns.removeClass 'selected'
    el = $(e.currentTarget)
    el.addClass 'selected'

    stage = _.find Game.instance.stages(), name: el.data('name')
    Game.instance.loadStage( stage ).done =>
      Q.pauseGame()
      HtmlComponent.showFadeable @playBtn

  onPlaySelected: ->
    HtmlComponent.hideFadeable @playBtn
    @hide()
    Q.unpauseGame()