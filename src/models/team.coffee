class Team
  @NONE  = new Team(name: "None",  rgb: [65, 65, 65])
  @RED   = new Team(name: "Red",   rgb: [255, 0, 0])
  @GREEN = new Team(name: "Green", rgb: [0, 255, 0])
  @BLUE  = new Team(name: "Blue",  rgb: [0, 0, 255])

  constructor: (params) ->
    _.extend @, params

  color: (opacity = 1)->
    "rgba(#{ @rgb.join(',') }, #{opacity})"
