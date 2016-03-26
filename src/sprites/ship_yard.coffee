Q.Sprite.extend 'ShipYard',
  init: (p) ->
    @_super p,
      asset            : 'ship_yard/green.png'
      type             : Q.SPRITE_DEFAULT
      sensor           : true
      isBuilding       : false
      buildRate        : 6000
      canChangeTeams   : false
      absorptionTarget : 250
      angle            : Q.random(0, 360)

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

    radius = @width() * (@p.scale or 1) / 2
    dx     = @p.x - x
    dy     = @p.y - y
    rSum   = radius + 1
    (dx * dx) + (dy * dy) <= (rSum * rSum)

  onAbsorptionTargetMet: ->
    @shipBuilder.startBuilding()

  onAbsorbed: (entity) ->
    @stage.insert new Q.ShieldFlare
      x      : @p.x
      y      : @p.y
      color  : entity.teamResource.val().color(0.8)
      radius : ( @width() / 2 + 20 ) * (@p.scale or 1)
,
  createWith: (p) ->
    on: (stage) ->
      stage.insert( new Q.ShipYard p )
