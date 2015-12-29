class AggressiveTeam extends TeamStrategy
  constructor: ->
    super
    _.each @ownPlanets(), @groupPlanetShips

  step: ->
    @attackGroupSize ?= Q.random 8, 15
    _.each @ownPlanets(), (planet) =>
      return unless shipGroup = planet.shipGroup
      return unless shipGroup.length() >= @attackGroupSize

      shipGroup.moveTo @bestTargetFor( planet )
      shipGroup.reset() # reset to refill

  bestTargetFor: (sprite) ->
    target = Target.parse sprite
    @closest().unoccupiedPlanet().to( target ) or @closest().enemyPlanet().to( target )

  onPlanetWon: ({ planet }) ->
    @groupPlanetShips planet

  onPlanetLost: ({ planet }) ->
    planet.off 'shipBuilder:shipBuilt', planet.shipGroup, 'add'
    return unless @ownPlanets().length is 0

    group = new ShipGroup( @ownShips() )
    group.moveTo @bestTargetFor( group )

  groupPlanetShips: (planet) ->
    planet.shipGroup?.reset() or planet.shipGroup = new ShipGroup()
    planet.on 'shipBuilder:shipBuilt', planet.shipGroup, 'add'
