class Path
  constructor: (targets = []) ->
    array = @set targets

    # delegate array fns
    [ 'pop', 'shift', 'indexOf' ].forEach (fnName) =>
      @[fnName] = (args...) -> array[fnName](args...)

  add: (target, at) ->
    target = Target.parse target
    if at then @items.splice(at, 0, target) else @items.push( target )

  remove: (target) ->
    @items = _.without @items, Target.parse( target )

  current: ->
    @items[0]

  moveNext: ->
    @items.shift()
    @current()

  isAvoidingHit: ->
    @current()?.type is 'hit'

  moveToThenResume: (target) ->
    @moveNext() if @isAvoidingHit()
    @items.unshift Target.parse( target )

  set: (targets = []) ->
    @items = _.map targets, Target.parse

  clear: ->
    @items = []