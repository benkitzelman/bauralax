class AggressiveTeam extends TeamStrategy
  step: ->
    @team.attackGroupStrength ?= Q.random 8, 65
    _.each @ownPlanets(), (planet) =>
      shipGroup = @idleShipsFrom( planet )
      return unless shipGroup.hitPoints() >= @team.attackGroupStrength

      shipGroup.moveNext @bestTargetFor( planet )
      shipGroup.reset() # reset to refill
      delete @team.attackGroupStrength

  idleShipsFrom: (planet) ->
    new ShipGroup( super( planet ) )

  bestTargetFor: (sprite) ->
    target = Target.parse sprite
    @closest().unoccupiedPlanet().to( target ) or @closest().enemyShipYard().to( target ) or @closest().enemyPlanet().to( target )

  onPlanetLost: ({ planet }) ->
    return unless @ownPlanets().length is 0

    group = new ShipGroup( @ownShips() )
    group.moveTo @bestTargetFor( group )

