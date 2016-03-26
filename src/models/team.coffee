class Team extends Q.Evented
  @NONE  = new Team(name: "None",  teamCollisionMask: 1, rgb: [65, 65, 65])
  @RED   = new Team(name: "Red",   teamCollisionMask: 2, rgb: [255, 0, 0])
  @GREEN = new Team(name: "Green", teamCollisionMask: 3, rgb: [45, 205, 45])
  @BLUE  = new Team(name: "Blue",  teamCollisionMask: 4, rgb: [0, 0, 255])

  constructor: (params) ->
    _.extend @, params
    @useStrategy( @strategy ) if @strategy

  color: (opacity = 1)->
    "rgba(#{ @rgb.join(',') }, #{opacity})"

  useStrategy: (TeamStrategyClass) ->
    @_strategy = new TeamStrategyClass( this )
    this

  step: (dt) ->
    @_strategy?.step dt
