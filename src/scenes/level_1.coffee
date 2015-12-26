Q.scene "level1", (stage) ->
  planets = [
    planetOne   = new Q.Planet(x: 300, y: 100,  team: Team.RED)
    planetTwo   = new Q.Planet(x: 400, y: 400,  team: Team.GREEN)
    planetThree = new Q.Planet(x: 500, y: 200,  team: Team.BLUE)
  ]

  stage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]
  planets.forEach (p) -> stage.insert(p)

  stage.add "viewport"
  stage.add "selectionControls"
