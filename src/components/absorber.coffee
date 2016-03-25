Q.component 'absorber',
  added: ->
    @reset()

  absorbableTypes: ->
    @entity.p.absorbableTypes or [ 'Ship' ]

  canBeAbsorbed: (sprite) ->
    return false if @hasBeenAbsorbed( sprite )
    _.any @absorbableTypes(), (type) ->
      sprite.isA( type ) and sprite.absorbable

  absorber: ->
    _.first( @absorbed )?.team

  valueFor: (sprite) ->
    absorber = @absorber()
    if not absorber or absorber is sprite.teamResource.val()
      sprite.absorbable.value()
    else
      sprite.absorbable.value() * -1

  absorb: (sprite) ->
    return unless @canBeAbsorbed( sprite )
    return if @absorbedPerc() >= 1
    
    @absorbed.push(sprite: sprite, team: sprite.teamResource.val(), val: @valueFor( sprite ) )
    sprite.absorbable.absorb @entity
    @updateProgressBar()
    @entity.trigger 'absorption:absorbed', sprite

    return @reset() if @absorbedValue() <= 0
    return unless @absorbedPerc() >= 1

    @entity.trigger 'absorption:target-met', @absorber()
    @reset() if @entity.p.canChangeTeams

  reset: ->
    @absorbed = []
    @entity.off "hit.sprite", @, 'onCollision'
    @entity.on "hit.sprite", @, 'onCollision'

  updateProgressBar: ->
    if not @_progressBar
      scale = @entity.p.scale or 1
      @_progressBar = new Q.ProgressBar(
        x: @entity.p.x - (@entity.width() * scale / 2 + 5 + 30),
        y: @entity.p.y - (@entity.height() * scale / 2)
      )
      @entity.stage.insert @_progressBar

    @_progressBar.set @absorbedPerc(), @absorber()?.color(1)

  absorptionTarget: ->
    @entity.p.absorptionTarget or 2

  absorbedValue: ->
    _.reduce @absorbed, (val, a) ->
      val += a.val or 0
      _.max [ val, 0 ]
    , 0

  absorbedPerc: ->
     @absorbedValue() / @absorptionTarget()

  hasBeenAbsorbed: (sprite) ->
    !!_.find @absorbed, (a) -> a.sprite is sprite

  onCollision: (collision) ->
    isReclaimingShip = =>
      collision.obj.isA("Ship") and @entity.teamResource.isTeammate( collision.obj ) and hasTargetedEntity()

    hasAbsorbedOtherTeams = =>
      @absorber() and @entity.teamResource.val() isnt @absorber()

    hasTargetedEntity = =>
      collision.obj.currentTarget().hasTargeted( @entity )

    isEnemy = =>
      not @entity.teamResource?.isTeammate( collision.obj )

    isAttackingEnemy = =>
      @entity.p.canChangeTeams and isEnemy() and hasTargetedEntity()

    isPoweringUpOwnAsset = =>
      @entity.p.canChangeTeams is false and not isEnemy() and hasTargetedEntity()

    isReclaimingLostPower = =>
      isReclaimingShip() and hasAbsorbedOtherTeams()
    #--

    return if collision.obj.isDestroyed
    return @absorb( collision.obj ) if isAttackingEnemy()
    return @absorb( collision.obj ) if isReclaimingLostPower()
    return @absorb( collision.obj ) if isPoweringUpOwnAsset()

