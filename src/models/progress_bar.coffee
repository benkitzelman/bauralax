class ProgressBar
  @instance = ->
    @_bar ?= new ProgressBar
    @_bar

  constructor: ->
    @assetsLoading = new $.Deferred
    @container     = $('#loading')
    @el            = $('#loading_progress')

  progressCallback: (loaded, total) =>
    perc = Math.floor( loaded / total * 100 )
    @el.width(perc + '%')
    return @assetsLoading unless perc >= 100

    @container.addClass 'hide'
    @assetsLoading.resolve()

