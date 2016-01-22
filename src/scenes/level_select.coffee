class LevelSelect extends Menu
  @register()

  addUI: ->
    @container = @QStage.insert( new Q.UI.Container
      x: Q.width/2, y: Q.height/2, fill: "rgba(0,0,0,0.5)"
    )

    label  = new Q.UI.Text( x: 0, y: 0, color: "#CCCCCC", label: "Bauralax" )
    button = new Q.UI.Button( x: 0, y: 50, fill: "#CCCCCC", label: "Level 1" )
    button.on "click", @, 'onTryAgain'

    @container.insert label

    _.each Game.instance.stages(), (stage, i) =>
      y = (i * 50) + 50
      button  = new Q.UI.Button( x: 0, y: y, fill: "#CCCCCC", label: stage.name )
      handler = @onLoadStage.bind @, stage
      button.on "click", handler
      @container.insert button

    @container.fit 50

  onLoadStage: (stage) ->
    stage.load()
