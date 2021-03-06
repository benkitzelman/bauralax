Q.Sprite.extend "Planet",
  init: (p) ->
    scale   = _.max [0.6, (Math.ceil(Math.random() * 10) / 10)]
    texture = 'planets/none/0.png'

    @_super Q._extend
      sensor           : true
      asset            : "planets/planet0.png"
      texture          : texture
      textureWidth     : 550
      frameX           : -Q.random( 50, Q.asset( texture ).width )
      spinSpeed        : Q.random(2, 5) / 15
      spinDirection    : [ 1, -1 ][ Q.random 0, 1 ]
      scale            : scale
      team             : Team.NONE
      type             : Q.SPRITE_DEFAULT
      buildRate        : 2000
      isBuilding       : true
      absorptionTarget : 50
      canChangeTeams   : true
      angle            : Q.random(-45, 45)
    , p

    @p.scaledTexture = @scaledTexture()

    @add 'teamResource'
    @add 'shipBuilder'
    @add 'absorber'

    @on 'absorption:target-met', @, 'onAbsorptionTargetMet'
    @on 'absorption:absorbed', @, 'onAbsorbed'

    @updateForTeam()

  width: ->
    @asset()?.width or @sheet()?.tileW

  height: ->
    @asset()?.height or @sheet()?.tileH

  randomTeamTexture: (filePrefix) ->
    fileName =_.filter([ filePrefix, "#{ Q.random(0, 1) }"]).join('_')
    asset    = "#{ fileName }.png"
    return "planets/#{ team.toLowerCase()}/#{ asset }" if team = @p.team?.name
    "planets/none/#{ asset }"

  updateForTeam: ->
    @p.texture       = @randomTeamTexture()
    @p.nebulaTexture = @randomTeamTexture 'nebula'
    @teamResource.ignoreCollisionsWith 'Ship'

  draw: (ctx) ->
    @drawNebula ctx
    @drawImage ctx
    @drawTeamColors ctx

  drawNebula: (ctx) ->
    return if @teamResource.val() is Team.NONE

    nebula = Q.asset @p.nebulaTexture
    dim    = _.min([ nebula.width, nebula.height ]) * @p.scale * 2
    xy     = dim / 2

    ctx.save()

    ctx.globalCompositeOperation = 'lighter'
    ctx.globalAlpha = 0.3

    ctx.drawImage nebula, -xy, -xy, dim, dim

    ctx.restore()

  drawTeamColors: (ctx) ->
    ctx.save()

    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()

    outerRadius = @radius() + 30
    innerRadius = @radius() - 30

    gradient = ctx.createRadialGradient 0, 0, outerRadius, 0, 0, @radius()
    gradient.addColorStop 0, "transparent"
    gradient.addColorStop 1, @teamResource.val().color(0.3)

    ctx.fillStyle = gradient
    ctx.arc(0, 0, outerRadius, 0, 180)
    ctx.fill()

    ctx.restore()

  scaledTexture: ->
    texture      = Q.asset @p.texture
    diameter     = @radius() * 2
    ratio        = diameter / texture.height
    ratio  : ratio
    height : texture.height * ratio
    width  : texture.width * ratio

  drawImage: (ctx) ->
    texture      = Q.asset @p.texture
    textureEdgeX = -@p.scaledTexture.width + @radius()

    # create the mask for the image scroller
    drawImageClip = =>
      ctx.beginPath()
      ctx.arc 0, 0, @radius(), 0, Math.PI * 2, false
      ctx.closePath()
      ctx.clip()

    # draw shadows on left and right side of globe
    drawShadows = =>
      ctx.globalCompositeOperation = 'overlay'
      ctx.globalAlpha = 1.00

      # left
      ctx.beginPath()
      ctx.arc 0, 0, @radius(), Math.PI * 0.70, Math.PI * 1.30, false
      ctx.shadowColor   = "black"
      ctx.shadowBlur    = 5
      ctx.shadowOffsetX = 5
      ctx.stroke()
      ctx.closePath()

      # right
      ctx.beginPath()
      ctx.arc 0, 0, @radius(), -Math.PI * 0.30, Math.PI * 0.30, false
      ctx.shadowColor   = "black"
      ctx.shadowBlur    = 5
      ctx.shadowOffsetX = -5
      ctx.stroke()
      ctx.closePath()

    # draw the texture into the clip
    drawTexture = =>
      ctx.globalCompositeOperation = 'source-over'
      ctx.globalAlpha = 1

      ctx.drawImage(
        texture,
        Math.floor(@p.frameX), Math.floor(-@p.scaledTexture.height / 2),
        @p.scaledTexture.width, @p.scaledTexture.height
      )

      if @p.frameX <= textureEdgeX + ( @radius() * 2 )
        joinX = @p.frameX + @p.scaledTexture.width - 1

        ctx.drawImage(
          texture,
          Math.floor(joinX), Math.floor(-@p.scaledTexture.height / 2),
          @p.scaledTexture.width, @p.scaledTexture.height
        )
    #--

    ctx.save()

    drawImageClip()
    drawTexture()
    drawShadows()

    ctx.restore()

  step: (dt) ->
    hasScrolledToEndOfImage = =>
      @p.frameX <= -( @p.scaledTexture.width + @radius() )

    @p.frameX  = -@radius() if !@p.frameX or hasScrolledToEndOfImage()
    @p.frameX -= @p.spinSpeed or 1

  radius: ->
    @width() / 2

  isInBounds: (entityOrCoords) ->
    {x, y} = Target.parse( entityOrCoords )?.coords()
    return false unless x? and y?

    radius = @width() * (@p.scale or 1) / 2
    dx     = @p.x - x
    dy     = @p.y - y
    rSum   = radius + 1
    (dx * dx) + (dy * dy) <= (rSum * rSum)

  onAbsorptionTargetMet: (absorbingTeam) ->
    reliquishingTeam = @teamResource.val()
    @teamResource.val absorbingTeam
    @updateForTeam()

    reliquishingTeam.trigger 'planet-lost', { planet: @, conquoringTeam: absorbingTeam }
    absorbingTeam.trigger 'planet-won', { planet: @, reliquishingTeam }

    @absorber.reset()

  onAbsorbed: (entity) ->
    @stage.insert new Q.ShieldFlare
      x      : @p.x
      y      : @p.y
      color  : entity.teamResource.val().color(0.8)
      radius : (@radius() + 20 ) * @p.scale

    if @absorber.absorbedPerc() < 1
      @teamResource.allowCollisionsWith 'Ship'
    else
      @teamResource.ignoreCollisionsWith 'Ship'
