class TeamStrategy extends Resources
  constructor: (@team) ->
    super @team
    @bindEvents()

  step: ->
    console.warn 'empty strategy'

  bindEvents: ->
    @team.on 'planet-won', @, 'onPlanetWon'
    @team.on 'planet-lost', @, 'onPlanetLost'

  onPlanetWon: (planet) ->
  onPlanetLost: (planet) ->
