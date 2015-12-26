Q.Sprite.extend "Planet",
  init: (p) ->
    scale  = _.max [0.4, (Math.ceil(Math.random() * 10) / 10)]

    @_super Q._extend
      sensor           : true
      asset            : @randomAsset()
      scale            : scale
      team             : Team.NONE
      type             : Q.SPRITE_DEFAULT
      buildRate        : 2000
      shipEmitDistance : 20
      absorptionTarget : 20
    , p

    @add 'teamResource'
    @add 'shipBuilder'
    @add 'absorber'

    @on 'touch', @, 'onTouch'
    @on 'absorption:target-met', @, 'onAbsorptionTargetMet'
    @on 'absorption:absorbed', @, 'onAbsorbed'

  onTouch: (args...) ->
    console.log 'planet touch', args...

  randomAsset: ->
    assets = [0..1].map (i) -> "/assets/images/planet#{i}.png"
    assets[ Math.floor(Math.random() * 10) % (assets.length) ]

  draw: (ctx) ->
    @_super(ctx)
    ctx.save()

    ctx.globalCompositeOperation = 'lighter'
    ctx.beginPath()
    ctx.fillStyle = @team().color(0.25)
    ctx.arc(0, 0, @radius(), 0, 180)
    ctx.fill()

    ctx.restore()

  radius: ->
    @asset().width / 2

  onAbsorptionTargetMet: (absorbingTeam) ->
    @p.team = absorbingTeam

  onAbsorbed: (entity) ->
    @stage.insert new Q.ShieldFlare
      x      : @p.x
      y      : @p.y
      color  : entity.team().color(0.8)
      radius : (@radius() + 20 ) * @p.scale
