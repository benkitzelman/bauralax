class StageLostGame extends Stage
  @register()

  constructor: (@QStage) ->
    @setupStage()
    @container = @QStage.insert( new Q.UI.Container
      x: Q.width/2, y: Q.height/2, fill: "rgba(0,0,0,0.5)"
    )

    label  = new Q.UI.Text( x: 0, y: 0, color: "#CCCCCC", label: "You Lost" )
    button = new Q.UI.Button( x: 0, y: 50, fill: "#CCCCCC", label: "Try Again" )
    button.on "click", @, 'onTryAgain'

    @container.insert label
    @container.insert button
    @container.fit 50

  autoScale: -> 1

  onTryAgain: ->
    Game.instance.startingStage()