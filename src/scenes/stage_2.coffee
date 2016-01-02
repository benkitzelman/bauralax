class StageTwo extends Stage
  viewport:
    coords: { x: 400, y: 325 }

  planets: [
    (x: 200, y: 100, startingShipCount: 50, team: Team.RED)
    (x: 100, y: 550, startingShipCount: 50, team: Team.BLUE)
    (x: 700, y: 350, startingShipCount: 50, team: Team.GREEN)
    (x: 400, y: 200)
    (x: 300, y: 400)
    (x: 600, y: 500)
  ]

  enemyStrategem:
    RED  : { strategy: AggressiveTeam }
    BLUE : { strategy: AggressiveTeam }

