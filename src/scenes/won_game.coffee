class StageWonGame extends Menu
  @register()

  addUI: ->
    @container = @QStage.insert( new Q.UI.Container
      x: Q.width/2, y: Q.height/2, fill: "rgba(0,0,0,0.5)"
    )

    label    = new Q.UI.Text( x: 0, y: 0, color: "#CCCCCC", label: "You Won!" )
    nextBtn  = new Q.UI.Button( x: 0, y: 50, fill: "#CCCCCC", label: "Next Level" )
    nextBtn.on "click", @, 'onNextLevel'

    @container.insert label
    @container.insert nextBtn

    unless Game.instance.isLastStage()
      againBtn = new Q.UI.Button( x: 0, y: 100, fill: "#CCCCCC", label: "Play Again" )
      againBtn.on "click", @, 'onPlayAgain'
      @container.insert againBtn

    @container.fit 100

  onPlayAgain: ->
    Game.instance.startingStage()

  onNextLevel: ->
    Game.instance.nextStage()