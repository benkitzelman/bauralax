Q.component 'absorbable',
  absorb: (absorber) ->
    @entity.absorb?() or @entity.destroy()
    @entity.trigger 'absorbed', @entity, absorber

  value: ->
    @entity.p.absorptionValue or 1
