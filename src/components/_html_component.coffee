class HtmlComponent
  elements : {}
  events   : {}

  @showFadeable: (el) ->
    $(el).css(display: 'block')
    $(el).removeClass 'hide'

  @hideFadeable: (el) ->
    $(el).addClass 'hide'
    _.delay =>
      return unless $(el).hasClass 'hide'
      $(el).css(display: 'none')
    , 2000

  @isFadeableHidden: (el)->
    $(el).hasClass 'hide'

  constructor: ->
    @refreshElements()
    @bindEvents()

  refreshElements: ->
    @[v] = $(k) for k, v of (@elements or {})

  bindEvents: ->
    for eventAndSelector, fnName of (@events or {})
      bits      = eventAndSelector.split ' '
      eventName = bits.shift()
      selector  = bits.join ' '
      $(selector).off(eventName).on( eventName, @[fnName].bind(@) )

  isHidden: ->
    HtmlComponent.isFadeableHidden @el

  show: ->
    HtmlComponent.showFadeable @el

  hide: ->
    HtmlComponent.hideFadeable @el
