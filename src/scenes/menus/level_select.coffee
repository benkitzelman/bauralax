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
    @levelSelector ?= (new LevelSelector()).render()
    @levelSelector.show()
