class ProgressBar extends HtmlComponent
  @instance = ->
    @_bar ?= new ProgressBar
    @_bar

  elements:
    "#loading"          : 'container'
    '#loading_progress' : 'el'

  constructor: ->
    super
    @whenAssetsLoad = new $.Deferred

  update: (loaded, total) =>
    perc = Math.floor( loaded / total * 100 )
    @el.width(perc + '%')
    return @whenAssetsLoad unless perc >= 100

    @container.addClass 'hide'
    @whenAssetsLoad.resolve()

