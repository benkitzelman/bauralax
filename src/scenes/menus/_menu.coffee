class Menu extends Scene
  @type = 'menu'

  constructor: (@QStage) ->
    @addBackground?()
    @addUI?()
