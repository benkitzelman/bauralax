class Path
  constructor: (targets = []) ->
    array = @set targets

    # delegate array fns
    [ 'pop', 'shift', 'indexOf' ].forEach (fnName) =>
      @[fnName] = (args...) -> array[fnName](args...)

  add: (target, at) ->
    target = Target.parse target
    if at then @_path.splice(at, 0, target) else @_path.push( target )

  remove: (target) ->
    @_path = _.without @_path, Target.parse( target )

  current: ->
    @_path[0]

  moveNext: ->
    @_path.shift()
    @current()

  isAvoidingHit: ->
    @current()?.type is 'hit'

  moveToThenResume: (target) ->
    @moveNext() if @isAvoidingHit()
    @_path.unshift Target.parse( target )

  set: (targets = []) ->
    @_path = _.map targets, Target.parse