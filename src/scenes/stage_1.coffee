class StageOne extends Stage
  planets: [
    { x: 300, y: 100, startingShipCount: 50, team: Team.RED  }
    { x: 500, y: 200, startingShipCount: 50, team: Team.BLUE }
    { x: 400, y: 400, startingShipCount: 50, team: Team.GREEN }
  ]

  enemyStrategem:
    RED  : { strategy: AggressiveTeam }
    BLUE : { strategy: AggressiveTeam }

