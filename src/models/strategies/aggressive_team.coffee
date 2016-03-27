class AggressiveTeam extends TeamStrategy
  step: ->
    @team.attackGroupStrength ?= Q.random 8, 65
    _.each @ownPlanets(), (planet) =>
      # shipGroup = @idleShipsFrom( planet )
      shipGroup = @idleShips()
      return unless shipGroup.hitPoints() >= @team.attackGroupStrength

      shipGroup.moveNext @bestTargetFor( planet )
      shipGroup.reset() # reset to refill
      delete @team.attackGroupStrength

  idleShipsFrom: (planet) ->
    new ShipGroup( super( planet ) )

  idleShips: ->
    new ShipGroup( super() )

  bestTargetFor: (sprite) ->
    target = Target.parse sprite
    @closest().unoccupiedPlanet().to( target ) or @closest().enemyShipBuilder().withLowestAbsorptionCost( target )

  onPlanetLost: ({ planet }) ->
    return unless @ownPlanets().length is 0

    group  = new ShipGroup( @ownShips() )
    target = @closest().planet().withLowestAbsorptionCost()
    group.moveTo target

