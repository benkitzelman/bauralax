class StageOne extends Stage
  # viewport:
  #   coords: { x: 350, y: 350 }

  planets: [
    { x: 200, y: 150, startingShipCount: 50, team: Team.RED  }
    { x: 500, y: 150, startingShipCount: 50, team: Team.BLUE }
    { x: 350, y: 350, team: Team.NONE                        }
    { x: 350, y: 550, startingShipCount: 50, team: Team.GREEN }
  ]

  enemyStrategem:
    RED  : { strategy: AggressiveTeam }
    BLUE : { strategy: AggressiveTeam }

