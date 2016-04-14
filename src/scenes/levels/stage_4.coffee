class StageFour extends Stage
  viewport:
    coords : { x: 600, y: 700 }
    scale  : 1

  planets: [
    # middle axis
    (x: 600, y: 100, startingShipCount: 50, team: Team.RED)
    (x: 600, y: 400, startingShipCount: 50, team: Team.RED)
    (x: 600, y: 700, startingShipCount: 50, team: Team.GREEN)
    (x: 600, y: 1000, startingShipCount: 50, team: Team.BLUE)
    (x: 600, y: 1300, startingShipCount: 50)
  ]

  enemyStrategem:
    RED  : { strategy: AggressiveTeam }
    BLUE : { strategy: AggressiveTeam }

