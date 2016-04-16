class HtmlComponent
  elements : {}
  events   : {}

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
    @el.hasClass 'hide'

  show: ->
    @el.removeClass 'hide'

  hide: ->
    @el.addClass 'hide'