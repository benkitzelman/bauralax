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

  invoke: (fnName, args...) ->
    _.each @items, (i) -> i[fnName]?.apply( i, args )

  length: ->
    @items.length

  isEmpty: ->
    @length() is 0