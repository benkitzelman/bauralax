class StageDebug extends Stage
  planets : [
    (x: 500, y: 200, startingShipCount: 0, team: Team.BLUE)
    (x: 500, y: 400, startingShipCount: 50, team: Team.GREEN)
  ]

  enemyStrategem:
    BLUE : { strategy: AggressiveTeam }
