class TeamStrategy
  constructor: (@team) ->
    @bindEvents()

  step: ->
    console.warn 'empty strategy'

  bindEvents: ->
    @team.on 'planet-won', @, 'onPlanetWon'
    @team.on 'planet-lost', @, 'onPlanetLost'

  onPlanetWon: (planet) ->
  onPlanetLost: (planet) ->

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
      enemyShipYard: =>
        sprites = _.flatten _.values @enemyShipYards()
        fn

      enemyPlanet: =>
        sprites = _.flatten _.values @enemyPlanets()
        fn

      enemyShip: =>
        sprites = _.flatten _.values @enemyShips()
        fn

      unoccupiedPlanet: =>
        sprites = @unoccupiedPlanets()
        fn

      to: (target) ->
        { x, y } = target.coords()
        _.first _.sortBy(sprites, (s) ->
          Q.distance( x, y, s.p.x, s.p.y )
        )

