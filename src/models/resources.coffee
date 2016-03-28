class Resources
  constructor: (@team) ->

  enemyResources: (type) ->
    resources = _.select Q.select( type )?.items, (s) => s.teamResource.val() not in [ @team, Team.NONE ]
    _.groupBy resources, (r) -> r.teamResource.val()?.name

  teamResources: (team, type) ->
    _.select Q.select( type )?.items, (s) -> s.teamResource.val() is team

  teamShips         : (team) -> @teamResources( team, "Ship" )
  teamPlanets       : (team) -> @teamResources( team, "Planet" )
  ownResources      : (type) -> @teamResources( @team, type )
  ownShips          : -> @ownResources( "Ship" )
  ownPlanets        : -> @ownResources( "Planet" )
  ownShipYards      : -> @ownResources( "ShipYard" )
  enemyShips        : -> @enemyResources( "Ship" )
  enemyPlanets      : -> @enemyResources( "Planet" )
  enemyShipYards    : -> @enemyResources( "ShipYard" )
  unoccupiedPlanets : -> @teamResources( Team.NONE, "Planet" )
  idleShips         : -> _.select @ownShips(), (s) -> s.isIdle()
  shipsFrom         : (planet) -> _.select @ownShips(), builder: planet
  idleShipsFrom     : (planet) -> _.select @shipsFrom( planet ), (s) -> s.isIdle()

  closest: ->
    sprites = []
    fn =
      planet: =>
        sprites = Q.select( 'Planet' )?.items
        fn

      enemyShipYard: =>
        sprites = _.flatten _.values @enemyShipYards()
        fn

      enemyPlanet: =>
        sprites = _.flatten _.values @enemyPlanets()
        fn

      enemyShip: =>
        sprites = _.flatten _.values @enemyShips()
        fn

      enemyShipBuilder: =>
        sprites = _.flatten _.map( [ @enemyShipYards(), @enemyPlanets() ], _.values )
        fn

      unoccupiedPlanet: =>
        sprites = @unoccupiedPlanets()
        fn

      withLowestAbsorptionCost: (target) =>
        _.first _.sortBy(sprites , (s) =>

          sortVal  = s.absorber.absorbedValue()
          sortVal *= -1 if s.absorber.absorber() is @team

          if target
            { x, y } = target.coords()
            sortVal += Q.distance( x, y, s.p.x, s.p.y )

          sortVal
        )

      to: (target) ->
        { x, y } = target.coords()
        _.first _.sortBy(sprites, (s) ->
          Q.distance( x, y, s.p.x, s.p.y )
        )


