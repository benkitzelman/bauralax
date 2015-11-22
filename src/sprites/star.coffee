Q.Sprite.extend 'Star',

  init: (p) ->
    @_super p,
      x: Math.random() * Q.width
      y: Math.random() * Q.height
      scale: Math.max Math.random(), .3
      asset: '/assets/images/star.png'
      type: Q.SPRITE_NONE
