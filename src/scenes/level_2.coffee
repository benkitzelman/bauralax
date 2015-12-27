Q.scene "level2", (stage) ->
  planets = [
    planetOne   = new Q.Planet(x: 200, y: 100,  team: Team.RED)
    planetOne   = new Q.Planet(x: 600, y: 500,  team: Team.RED)
    planetTwo   = new Q.Planet(x: 400, y: 200,  team: Team.GREEN)
    planetTwo   = new Q.Planet(x: 700, y: 350,  team: Team.GREEN)
    planetThree = new Q.Planet(x: 300, y: 400,  team: Team.BLUE)
    planetThree = new Q.Planet(x: 200, y: 350,  team: Team.BLUE)
  ]

  stage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]
  planets.forEach (p) -> stage.insert(p)

  stage.add "viewport"
  stage.add "selectionControls"

  Team.GREEN.useStrategy( AggressiveTeam )
  Team.RED.useStrategy( AggressiveTeam )

  stage.on 'prestep', (dt) ->
    Team.RED.step( dt )
    Team.GREEN.step( dt )
    Team.BLUE.step( dt )