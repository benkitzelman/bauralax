Q.scene "debug", (stage) ->
  planets = [
    # planetOne = new Q.Planet(x: 300, y: 100,  team: Team.RED)
    planetTwo = new Q.Planet(x: 500, y: 200,  team: Team.BLUE)
  ]

  stage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]
  planets.forEach (p) -> stage.insert(p)

  stage.add "viewport"
  stage.add "selectionControls"

  # Team.RED.useStrategy( AggressiveTeam )

  stage.on 'prestep', (dt) ->
    Team.RED.step( dt )