class StageWonGame extends Menu
  @register()

  addUI: ->
    @container = @QStage.insert( new Q.UI.Container
      x: Q.width/2, y: Q.height/2, fill: "rgba(0,0,0,0.5)"
    )

    label = new Q.UI.Text( x: 0, y: 0, color: "#CCCCCC", label: "You Won!" )
    @container.insert label

    if Game.instance.isLastStage()
      returnBtn = new Q.UI.Button( x: 0, y: 50, fill: "#CCCCCC", label: "Main Menu" )
      returnBtn.on "click", @, 'onReturnToMain'
      @container.insert returnBtn

    else
      nextBtn  = new Q.UI.Button( x: 0, y: 50, fill: "#CCCCCC", label: "Next Level" )
      nextBtn.on "click", @, 'onNextLevel'
      @container.insert nextBtn

    @container.fit()

  onReturnToMain: ->
    Game.instance.mainMenu()

  onNextLevel: ->
    Game.instance.nextStage()