Q.component 'shipAbsorber',

  added: ->
    @entity.on "hit.sprite", @, 'onCollision'

  onCollision: ->
