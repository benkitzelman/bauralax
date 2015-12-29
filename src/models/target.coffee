class Target
  @AIMLESS = 'aimless'
  @COORDS  = 'coords'
  @ENTITY  = 'entity'

  @parse = (target) ->
    return null unless target
    return target if target instanceof Target
    target = target.coords?() or target
    new Target target

  constructor: (coordsOrEntity = {}) ->
    @obj = coordsOrEntity

  isEntity: ->
    @obj.p?

  coords: ->
    target = if @isEntity() then @obj.p else @obj
    _.pick target, 'x', 'y'

  hasTargeted: (entity) ->
    return false if @type() is Target.AIMLESS
    @obj is entity or entity.isInBounds( @coords() )

  type: ->
    return Target.ENTITY if @isEntity()
    @obj.type or Target.COORDS
