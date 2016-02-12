Q.Sprite.extend 'BuildSite',
  init: (p) ->
    @_super p,
      asset   : 'planets/nebula/blue.png' # TODO: Find a good asset
      type    : Q.SPRITE_DEFAULT


    @p.x = @asset().width * @p.scale / 2 * -1
    @p.y = @asset().height / 2 * -1
