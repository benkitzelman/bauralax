class Menu extends Scene
  @type = 'menu'

  style:
    heading:
      color : Q.colorString [255,255,255,0.8]
      size  : Q.percentToPx 0.05, 'width'
      font  : "Android"

    button:
      color : Q.colorString [255,255,255,0.8]
      size  : Q.percentToPx 0.02, 'width'
      font  : "Neuro"


  constructor: (@QStage) ->
    @addBackground?()
    @addUI?()

  placeInCenter: (element) ->
    element.p.x = Q.center().x
    element.p.y = Q.center().y - element.p.h / 2
