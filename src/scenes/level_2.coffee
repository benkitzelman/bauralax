Q.scene "level2", (stage) ->
  stage.add "viewport"
  stage.add "selectionControls"

  planets = [
    new Q.Planet(x: 200, y: 100, startingShipCount: 50, team: Team.RED)
    new Q.Planet(x: 100, y: 550, startingShipCount: 50, team: Team.BLUE)
    new Q.Planet(x: 700, y: 350, startingShipCount: 50, team: Team.GREEN)
    new Q.Planet(x: 400, y: 200)
    new Q.Planet(x: 300, y: 400)
    new Q.Planet(x: 600, y: 500)
  ]

  stage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]
  planets.forEach (p) -> stage.insert(p)

  Team.BLUE.useStrategy AggressiveTeam
  Team.RED.useStrategy AggressiveTeam

  stage.on 'prestep', (dt) ->
    Team.RED.step dt
    Team.GREEN.step dt
    Team.BLUE.step dt