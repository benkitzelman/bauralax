class AggressiveTeam extends TeamStrategy
  step: ->
    @attackGroupSize ?= Q.random 8, 15
    _.each @ownPlanets(), (planet) =>
      shipGroup = @idleShipsFrom( planet )
      return unless shipGroup.length() >= @attackGroupSize

      shipGroup.moveNext @bestTargetFor( planet )
      shipGroup.reset() # reset to refill

  idleShipsFrom: (planet) ->
    new ShipGroup( super( planet ) )

  bestTargetFor: (sprite) ->
    target = Target.parse sprite
    @closest().unoccupiedPlanet().to( target ) or @closest().enemyPlanet().to( target )

  onPlanetLost: ({ planet }) ->
    return unless @ownPlanets().length is 0

    group = new ShipGroup( @ownShips() )
    group.moveTo @bestTargetFor( group )

