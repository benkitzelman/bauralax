class StageDebug extends Stage
  viewport:
    coords: { x: 500, y: 300 }

  planets : [
    (x: 500, y: 200, startingShipCount: 1, team: Team.BLUE)
    (x: 500, y: 400, startingShipCount: 50, team: Team.GREEN)
  ]

  enemyStrategem:
    BLUE : { strategy: AggressiveTeam }

