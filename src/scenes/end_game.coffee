Q.scene "endGame", (stage) ->
  container = stage.insert( new Q.UI.Container
    x: Q.width/2, y: Q.height/2, fill: "rgba(0,0,0,0.5)"
  )

  button = container.insert new Q.UI.Button( x: 0, y: 0, fill: "#CCCCCC", label: "Play Again" )
  # label  = container.insert new Q.UI.Text(x:10, y: -10 - button.p.h, label: stage.options.label)

  button.on "click", ->
    Q.clearStages()
    Q.stageScene 'level1'

  container.fit 20
