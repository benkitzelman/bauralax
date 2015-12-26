Q.component 'absorbable',
  absorb: (absorber) ->
    @entity.absorb?() or @entity.destroy()
    @entity.trigger 'absorbable:absorbed', @entity, absorber

  value: ->
    @entity.p.absorptionValue or 1
