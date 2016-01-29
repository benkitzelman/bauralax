class Menu extends Scene
  @type = 'menu'

  constructor: (@QStage) ->
    @addBackground?()
    @addUI?()

  placeInCenter: (element) ->
    element.p.x = Q.center().x
    element.p.y = Q.center().y - element.p.h / 2

    console.log Q.center(), element.p.w / 2, element.p.x