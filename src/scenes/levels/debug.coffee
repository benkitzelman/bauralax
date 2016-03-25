class StageDebug extends Stage
  viewport:
    coords: { x: 500, y: 300 }

  planets : [
    (x: 500, y: 200, startingShipCount: 0, team: Team.BLUE, isBuilding: false)
    (x: 500, y: 400, startingShipCount: 250, team: Team.GREEN, isBuilding: false)
  ]

  enemyStrategem:
    BLUE : { strategy: AggressiveTeam }

