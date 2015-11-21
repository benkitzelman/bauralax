Q.scene "level1", (stage) ->
  planets = [
    planetOne   = new Q.Planet(x: 300, y: 100)
    planetTwo   = new Q.Planet(x: 700, y: 500)
    planetThree = new Q.Planet(x: 1200, y: 300)
  ]

  stage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]
  planets.forEach (p) -> stage.insert(p)
