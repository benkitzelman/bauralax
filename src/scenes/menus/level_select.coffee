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
    @container = @QStage.insert( new Q.UI.Container
      fill: Q.colorString([255,255,255,0.15])
    )

    label  = new Q.UI.Text( x: 0, y: 0, color: @style.heading.color, label: ">GALACTIC SHIFT<", size: @style.heading.size, family: @style.heading.font )
    @QStage.insert label

    _.each Game.instance.stages(), (stage, i) =>
      padding = Q.percentToPx(0.03, 'width')
      y       = (i * (@style.button.size + padding)) + (padding * 2)

      name    = stage.name.replace(/stage/i, '')
      button  = new Q.UI.Button
        x         : 0
        y         : y
        fontColor : @style.button.color
        label     : name
        font      : "400 #{ @style.button.size }px #{ @style.button.font }"

      handler = @onLoadStage.bind @, stage

      button.on "click", handler
      @container.insert button

    @container.fit Q.percentToPx(0.01, 'height'), Q.percentToPx(0.2, 'width')

    @placeInCenter @container
    label.p.x = Q.center().x
    label.p.y = @container.p.y - label.p.h / 2


  onLoadStage: (stage) ->
    Game.instance.loadStage stage
