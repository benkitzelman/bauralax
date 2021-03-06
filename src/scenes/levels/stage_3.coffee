class StageThree extends Stage
  viewport:
    coords : { x: 600, y: 400 }
    scale  : 1.5

  planets: [
    # middle axis
    (x: 600, y: 100, startingShipCount: 50, team: Team.RED)
    (x: 600, y: 400, startingShipCount: 50, team: Team.GREEN)
    (x: 600, y: 700, startingShipCount: 50, team: Team.BLUE)

    # mid left
    (x: 400, y: 250)
    (x: 400, y: 550)

    # left
    (x: 200, y: 400, team: Team.RED)

    # mid right
    (x: 800, y: 250)
    (x: 800, y: 550)

    #right
    (x: 1000, y: 400, team: Team.RED)
  ]

  enemyStrategem:
    RED  : { strategy: AggressiveTeam }
    BLUE : { strategy: AggressiveTeam }

