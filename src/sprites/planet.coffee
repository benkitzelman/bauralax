Q.Sprite.extend "Planet",
  init: (p) ->
    scale   = _.max [0.6, (Math.ceil(Math.random() * 10) / 10)]
    texture = 'planets/red/0.png'

    @_super Q._extend
      sensor           : true
      asset            : "planets/planet0.png"
      texture          : 'planets/none/0.png'
      textureWidth     : 550
      frameX           : -Q.random( 0, Q.asset( texture ).width )
      spinSpeed        : Q.random(1, 5) / 10
      spinDirection    : [ 1, -1 ][ Q.random 0, 1 ]
      scale            : scale
      team             : Team.NONE
      type             : Q.SPRITE_DEFAULT
      buildRate        : 2000
      absorptionTarget : 50
      angle            : Q.random(-45, 45)
    , p

    @add 'teamResource'
    @add 'shipBuilder'
    @add 'absorber'

    @on 'absorption:target-met', @, 'onAbsorptionTargetMet'
    @on 'absorption:absorbed', @, 'onAbsorbed'

    @p.texture = @randomTeamTexture()

  width: ->
    @asset()?.width or @sheet()?.tileW

  height: ->
    @asset()?.height or @sheet()?.tileH

  randomTeamTexture: ->
    asset = "#{ Q.random(0, 1) }.png"
    return "planets/#{ team.toLowerCase()}/#{ asset }" if team = @p.team?.name
    "planets/none/#{ asset }"

  draw: (ctx) ->
    @drawImage ctx
    @drawTeamColors ctx

  drawTeamColors: (ctx) ->
    ctx.save()

    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()
    ctx.fillStyle = @teamResource.val().color(0.18  )
    ctx.arc(0, 0, @radius(), 0, 180)
    ctx.fill()

    ctx.restore()

  drawImage: (ctx) ->
    texture      = Q.asset @p.texture
    textureEdgeX = -texture.width + @radius()
    diameter     = @radius() * 2

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
      ctx.drawImage texture, @p.frameX, -texture.height / 2

      if @p.frameX <= textureEdgeX + diameter
        joinX = @p.frameX + texture.width
        ctx.drawImage texture, joinX, -texture.height / 2
    #--

    ctx.save()

    drawImageClip()
    drawTexture()
    drawShadows()

    ctx.restore()

  step: (dt) ->
    hasScrolledToEndOfImage = =>
      @p.frameX <= -( Q.asset( @p.texture ).width + @radius() )

    @p.frameX  = -@radius() if !@p.frameX or hasScrolledToEndOfImage()
    @p.frameX -= @p.spinSpeed or 1

  radius: ->
    @width() / 2

  isInBounds: (entityOrCoords) ->
    {x, y} = Target.parse( entityOrCoords )?.coords()
    return false unless x? and y?

    radius = @width() * @p.scale / 2
    dx     = @p.x - x
    dy     = @p.y - y
    rSum   = radius + 1
    (dx * dx) + (dy * dy) <= (rSum * rSum)

  onAbsorptionTargetMet: (absorbingTeam) ->
    reliquishingTeam = @teamResource.val()
    @teamResource.val absorbingTeam
    @p.texture = @randomTeamTexture()

    reliquishingTeam.trigger 'planet-lost', { planet: @, conquoringTeam: absorbingTeam }
    absorbingTeam.trigger 'planet-won', { planet: @, reliquishingTeam }

    @absorber.reset()

  onAbsorbed: (entity) ->
    @stage.insert new Q.ShieldFlare
      x      : @p.x
      y      : @p.y
      color  : entity.teamResource.val().color(0.8)
      radius : (@radius() + 20 ) * @p.scale
