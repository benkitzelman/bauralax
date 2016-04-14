class LevelSelect extends Menu
  @register()

  addBackground: ->
    center = Q.center()

    leftX  = center.x / 2
    rightX = center.x + ( center.x / 2 )

    topY    = center.y / 2
    bottomY = center.y + topY

    @QStage.insert(new Q.Background)
    @QStage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]
    @QStage.insert(new Q.Planet(x: leftX, y: topY, scale: 1, team: Team.GREEN))
    @QStage.insert(new Q.Planet(x: rightX, y: center.y, scale: 1.25, team: Team.RED))
    @QStage.insert(new Q.Planet(x: center.x - center.x / 4, y: bottomY, scale: 0.5, team: Team.BLUE))

  addUI: ->
    BUTTON_COLOR = "rgba(255,255,255, 0.8)"
    BUTTON_FONT  = "400 20px Neuro"

    @container = @QStage.insert( new Q.UI.Container
      fill: "rgba(255,255,255,0.15)"
    )

    label  = new Q.UI.Text( x: 0, y: 0, color: BUTTON_COLOR, label: ">GALACTIC SHIFT<", size: 50, family: 'Android' )
    @QStage.insert label

    _.each Game.instance.stages(), (stage, i) =>
      y = (i * 50) + 50

      name    = stage.name.replace(/stage/i, '')
      button  = new Q.UI.Button( x: 0, y: y, fontColor: BUTTON_COLOR, label: name, font: BUTTON_FONT )
      handler = @onLoadStage.bind @, stage

      button.on "click", handler
      @container.insert button

    @container.fit 20, 100

    @placeInCenter @container
    label.p.x = Q.center().x
    label.p.y = @container.p.y - label.p.h / 2


  onLoadStage: (stage) ->
    Game.instance.loadStage stage
