class AggressiveTeam extends TeamStrategy
  constructor: ->
    super
    _.each @ownPlanets(), @groupPlanetShips

  step: ->
    # console.log 'STEP', @ownPlanets().length
    @attackGroupSize ?= Q.random 8, 15
    _.each @ownPlanets(), (planet) =>
      return unless shipGroup = planet.shipGroup

      if shipGroup.length() >= @attackGroupSize
        shipGroup.moveTo @closestEnemyPlanet()
        shipGroup.reset() # reset to refill

  onPlanetWon: ({ planet }) ->
    @groupPlanetShips planet

  onPlanetLost: ({ planet }) ->
    planet.off 'shipBuilder:shipBuilt', planet.shipGroup.add

  groupPlanetShips: (planet) ->
    planet.shipGroup?.reset() or planet.shipGroup = new ShipGroup()
    planet.on 'shipBuilder:shipBuilt', planet.shipGroup.add
