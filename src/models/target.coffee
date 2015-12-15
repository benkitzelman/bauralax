class Target
  @parse = (target) ->
    return null unless target
    return target if target instanceof Target
    new Target target

  constructor: (coordsOrEntity = {}) ->
    @obj = coordsOrEntity

  isEntity: ->
    @obj.p?

  coords: ->
    target = if @isEntity() then @obj.p else @obj
    _.pick target, 'x', 'y'

  type: ->
    return 'entity' if @isEntity()
    @obj.type or 'coords'