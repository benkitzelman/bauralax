class TeamStrategy
  constructor: (@team) ->
    @bindEvents()

  step: ->
    console.warn 'empty strategy'

  bindEvents: ->
    @team.on 'planet-won', @onPlanetWon
    @team.on 'planet-lost', @onPlanetLost

  onPlanetWon: (planet) ->
  onPlanetLost: (planet) ->

  enemyResources: (type) ->
    resources = _.select Q.select( type )?.items, (s) => s.team() isnt @team
    _.groupBy resources, (r) -> r.team()?.name

  teamResources: (team, type) ->
    _.select Q.select( type )?.items, (s) -> s.team() is team

  teamShips    : (team) -> @teamResources( team, "Ship" )
  teamPlanets  : (team) -> @teamResources( team, "Planet" )
  ownResources : (type) -> @teamResources( @team, type )
  ownShips     : -> @ownResources( "Ship" )
  ownPlanets   : -> @ownResources( "Planet" )
  enemyShips   : -> @enemyResources( "Ship" )
  enemyPlanets : -> @enemyResources( "Planet" )

  closestEnemyPlanet: ->
    ownPlanet = _.first @ownPlanets()
    planets   = _.flatten _.values @enemyPlanets()
    _.first _.sortBy( planets, (planet) ->
      Q.distance ownPlanet.p.x, ownPlanet.p.y, planet.p.x, planet.p.y
    )

