class Collection extends Q.Evented
  constructor: (items = []) ->
    @reset()
    @add items

  add: (items = []) ->
    items = _.flatten [ items ]
    @items.push items...

  remove: (items = []) ->
    items = _.flatten [ items ]
    @items = _.without @items, items

  reset: ->
    @items = []
