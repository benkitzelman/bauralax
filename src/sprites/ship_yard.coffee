Q.Sprite.extend 'ShipYard',
  init: (p) ->
    @_super p,
      asset            : 'ship_yard/green.png'
      type             : Q.SPRITE_DEFAULT
      sensor           : true
      isBuilding       : false
      buildRate        : 6000
      canChangeTeams   : false
      absorptionTarget : 50
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

  explode: (color)->
    @stage.insert new Q.Explosion
      x     : @p.x
      y     : @p.y
      vx    : @p.vx
      vy    : @p.vy
      radius: @width() + 30
      color : color or @teamResource.val().color(0.75)

    Q.audio.play 'ship_explosion.mp3'
    @destroy()

  onAbsorptionTargetMet: ->
    @shipBuilder.startBuilding()

  onAbsorbed: (entity) ->
    @explode() if @absorber.absorber() isnt @p.team

  draw: (ctx) ->
    drawImage = =>
      ctx.save()
      ctx.globalCompositeOperation = 'lighter'
      ctx.drawImage @asset(), -@p.cx, -@p.cy
      ctx.restore()

    drawShields = =>
      flareWidth = _.min [ 20, @p.radius * .5 ]
      outer      = @p.radius + 7
      inner      = outer - flareWidth

      ctx.save()
      ctx.globalCompositeOperation = 'lighter'
      ctx.beginPath()

      ctx.arc 0, 0, outer, 0, 180

      grd = ctx.createRadialGradient 0, 0, outer, 0, 0, inner
      grd.addColorStop 0, @p.team.color(0.8)
      grd.addColorStop 1, "transparent"
      ctx.fillStyle = grd
      ctx.fill()

      ctx.closePath()
      ctx.restore()
    #--

    drawImage()
    drawShields() if @shipBuilder.isBuilding()

,
  createWith: (p) ->
    on: (stage) ->
      stage.insert( new Q.ShipYard p )
