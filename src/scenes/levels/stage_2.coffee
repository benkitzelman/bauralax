class StageTwo extends Stage
  viewport:
    coords : { x: 1200, y: 350 }
    scale  : 1.25

  planets: [
    (x: 700, y: 100, startingShipCount: 50, team: Team.RED)
    (x: 600, y: 550, startingShipCount: 50, team: Team.BLUE)
    (x: 1200, y: 350, startingShipCount: 50, team: Team.GREEN)
    (x: 900, y: 200)
    (x: 800, y: 400)
    (x: 1100, y: 500)
  ]

  enemyStrategem:
    RED  : { strategy: AggressiveTeam }
    BLUE : { strategy: AggressiveTeam }

