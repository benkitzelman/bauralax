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
    sprite.absorbable.absorb( @entity )
    @entity.trigger 'absorption:absorbed', sprite

    return unless @absorbedPerc() >= 1

    @entity.trigger 'absorption:target-met', @absorber()
    @reset()

  reset: ->
    @absorbed = []
    @entity.off "hit.sprite", @, 'onCollision'
    @entity.on "hit.sprite", @, 'onCollision'

  absorptionTarget: ->
    @entity.p.absorptionTarget or 2

  absorbedValue: ->
    _.reduce @absorbed, ((val, a) -> val += a.val or 0), 0

  absorbedPerc: ->
     @absorbedValue() / @absorptionTarget()

  hasBeenAbsorbed: (sprite) ->
    !!_.find @absorbed, (a) -> a.sprite is sprite

  onCollision: (collision) ->
    return if collision.obj.isDestroyed
    @absorb( collision.obj ) unless @entity.teamResource?.isTeammate( collision.obj )

