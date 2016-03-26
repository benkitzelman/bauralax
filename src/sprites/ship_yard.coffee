Q.Sprite.extend 'ShipYard',
  init: (p) ->
    @_super p,
      asset            : 'ship_yard/green.png'
      type             : Q.SPRITE_DEFAULT
      sensor           : true
      isBuilding       : false
      buildRate        : 6000
      canChangeTeams   : false
      absorptionTarget : 100
      angle            : Q.random(0, 360)

    @p.radius = @width() * (@p.scale or 1) / 2

    @add 'teamResource'
    @add 'absorber'
    @add 'shipBuilder'

    @on 'absorption:target-met', @, 'onAbsorptionTargetMet'
    @on 'absorption:absorbed', @, 'onAbsorbed'

  width: ->
    @asset()?.width or @sheet()?.tileW

  height: ->
    @asset()?.height or @sheet()?.tileH

  isInBounds: (entityOrCoords) ->
    {x, y} = Target.parse( entityOrCoords )?.coords()
    return false unless x? and y?

    dx     = @p.x - x
    dy     = @p.y - y
    rSum   = @p.radius + 1
    (dx * dx) + (dy * dy) <= (rSum * rSum)

  onAbsorptionTargetMet: ->
    @shipBuilder.startBuilding()
    @stage.insert new Q.ShieldFlare
      x           : @p.x
      y           : @p.y
      color       : @p.team.color(0.8)
      radius      : @p.radius + 5
      opacityRate : 0

  onAbsorbed: (entity) ->
    
,
  createWith: (p) ->
    on: (stage) ->
      stage.insert( new Q.ShipYard p )
