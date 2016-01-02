Q.Sprite.extend "Planet",
  init: (p) ->
    scale  = _.max [0.6, (Math.ceil(Math.random() * 10) / 10)]

    @_super Q._extend
      sensor           : true
      asset            : @randomAsset()
      scale            : scale
      team             : Team.NONE
      type             : Q.SPRITE_DEFAULT
      buildRate        : 2000
      absorptionTarget : 50
    , p

    @add 'teamResource'
    @add 'shipBuilder'
    @add 'absorber'

    @on 'absorption:target-met', @, 'onAbsorptionTargetMet'
    @on 'absorption:absorbed', @, 'onAbsorbed'

  randomAsset: ->
    assets = [0..1].map (i) -> "/assets/images/planet#{i}.png"
    assets[ Math.floor(Math.random() * 10) % (assets.length) ]

  draw: (ctx) ->
    @_super(ctx)
    ctx.save()

    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()
    ctx.fillStyle = @teamResource.val().color(0.18)
    ctx.arc(0, 0, @radius(), 0, 180)
    ctx.fill()

    ctx.restore()

  radius: ->
    @asset().width / 2

  isInBounds: (entityOrCoords) ->
    {x, y} = Target.parse( entityOrCoords )?.coords()
    return false unless x? and y?

    radius = @asset().width * @p.scale / 2
    dx     = @p.x - x
    dy     = @p.y - y
    rSum   = radius + 1
    (dx * dx) + (dy * dy) <= (rSum * rSum)

  onAbsorptionTargetMet: (absorbingTeam) ->
    reliquishingTeam = @teamResource.val()
    @teamResource.val absorbingTeam

    reliquishingTeam.trigger 'planet-lost', { planet: @, conquoringTeam: absorbingTeam }
    absorbingTeam.trigger 'planet-won', { planet: @, reliquishingTeam }

    @absorber.reset()

  onAbsorbed: (entity) ->
    @stage.insert new Q.ShieldFlare
      x      : @p.x
      y      : @p.y
      color  : entity.teamResource.val().color(0.8)
      radius : (@radius() + 20 ) * @p.scale
