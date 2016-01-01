class TouchInput extends Q.Evented

  constructor: (opts) ->
    _.extend @, opts

    @state = 'waiting'

    @chain 'touch', @onTouch
    @chain 'touchEnd', @onTouchEnd
    @chain 'drag', @onDrag

  selectionState: ->
    @state

  destroy: ->
    @unchain 'touch'
    @unchain 'touchEnd'
    @unchain 'drag'

  chain: (fnName, execFn) ->
    @wrappedFns ?= {}
    @wrappedFns[ fnName ] = originalFn = Q.touchInput[ fnName ]
    self = @
    Q.touchInput[ fnName ] = (args...) ->
      originalFn.apply Q.touchInput, args
      execFn.apply self, args

  unchain: (fnName) ->
    return unless originalFn = @wrappedFns[ fnName ]
    return unless Q.touchInput[ fnName ]
    Q.touchInput[ fnName ] = originalFn

  normalize: (touch, stage) ->
    stage   = stage or @stage
    canvasX = touch.offsetX or touch.layerX
    canvasY = touch.offsetY or touch.layerY

    if not canvasY or not canvasX
      if not Q.touch.offsetX
        el = Q.el
        Q.touch.offsetX = Q.touch.offsetY = 0
        while el = el.offsetParent
          Q.touch.offsetX += el.offsetLeft;
          Q.touch.offsetY += el.offsetTop;

      canvasX = touch.pageX - Q.touch.offsetX
      canvasY = touch.pageY - Q.touch.offsetY

    evt      = new Q.Evented()
    evt.grid = {}
    evt.p    = w:1, h:1, cx: 0, cy: 0
    evt.p.ox = evt.p.px = canvasX / Q.cssWidth * Q.width
    evt.p.oy = evt.p.py = canvasY / Q.cssHeight * Q.height

    if stage.viewport
      evt.p.px /= stage.viewport.scale
      evt.p.py /= stage.viewport.scale
      evt.p.px += stage.viewport.x
      evt.p.py += stage.viewport.y

    evt.p.x = evt.p.px
    evt.p.y = evt.p.py
    evt.obj = null
    evt

  onTouch: (e) ->
    touch = _.first( e.changedTouches or [ e ] )
    touch.identifier = touch.identifier or 0
    @activeTouch     = @normalize touch
    @trigger 'touch-start', @activeTouch

  onTouchEnd: (e) ->
    touch   = _.first( e.changedTouches or [ e ] )
    evtName = if @state is 'selecting' then 'touch-drag-end' else 'touch'
    @trigger evtName, @activeTouch, @normalize( touch )

    @state = 'waiting'
    delete @activeTouch

  onDrag: (e) ->
    return unless @activeTouch
    @state = 'selecting'
    touch = _.first( e.changedTouches or [ e ] )
    @trigger 'touch-drag-change', { origin: @activeTouch, current: @normalize( touch ) }

