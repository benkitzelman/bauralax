class AggressiveTeam extends TeamStrategy
  step: ->
    @team.attackGroupSize ?= Q.random 8, 65
    _.each @ownPlanets(), (planet) =>
      shipGroup = @idleShipsFrom( planet )
      return unless shipGroup.length() >= @team.attackGroupSize

      shipGroup.moveNext @bestTargetFor( planet )
      shipGroup.reset() # reset to refill
      delete @team.attackGroupSize

  idleShipsFrom: (planet) ->
    new ShipGroup( super( planet ) )

  bestTargetFor: (sprite) ->
    target = Target.parse sprite
    @closest().unoccupiedPlanet().to( target ) or @closest().enemyPlanet().to( target )

  onPlanetLost: ({ planet }) ->
    return unless @ownPlanets().length is 0

    group = new ShipGroup( @ownShips() )
    group.moveTo @bestTargetFor( group )

