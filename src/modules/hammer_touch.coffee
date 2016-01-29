Quintus.HammerTouch = (Q) ->
  touchType = null

  Q.touch = (type, stage) ->
    touchType = type or Q.SPRITE_UI

    Q.untouch()
    Q.hammerTouchInput = new HammerTouch() unless Q._touch
    Q

  Q.untouch = ->
    if Q.hammerTouchInput
      Q.hammerTouchInput.destroy()
      delete Q.hammerTouchInput
    Q

  Q.HammerTouch = class HammerTouch extends Q.Evented

    constructor: (opts) ->
      _.extend @, opts

      @touchedObjects = {}

      @hammertime = new Hammer Q.el, Hammer.defaults
      @hammertime.get('pinch').set(enable: true)

      @hammertime.on 'pinch', @onPinch
      @hammertime.on 'tap', @onTap
      @hammertime.on 'pan', @onPan

      Q.el.addEventListener 'scroll', @onScroll

    destroy: ->
      @hammertime.off 'pinch', @onPinch
      @hammertime.off 'tap', @onTouch
      @hammertime.off 'pan', @offPan

      Q.el.removeEventListener 'scroll', @onScroll

    currentStage: ->
      @stage or Q.stage()

    normalize: (touch, stage) ->
      stage   = stage or @currentStage()
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

    scaleCoords: (coords) ->
      scale     = @currentStage().viewport?.scale or 1
      viewportX = @currentStage().viewport?.x or 0
      viewportY = @currentStage().viewport?.y or 0

      x: ( coords.x / Q.cssWidth * Q.width / scale ) + viewportX
      y: ( coords.y / Q.cssHeight * Q.height / scale ) + viewportY

    onTap: (e) =>
      trigger = (e, obj = @) =>
        obj.trigger "touch", e
        obj.trigger "touchEnd", e

      touch = _.first( e.changedPointers or [ e ] )
      pos   = @normalize touch
      stage = @currentStage()

      stage.regrid pos, true
      col     = stage.search pos, touchType
      pos.obj = col?.obj

      trigger pos

      if pos.obj
        touch =
          x     : pos.p.px
          y     : pos.p.py
          origX : pos.obj.p.x
          origY : pos.obj.p.y
          sx    : pos.p.ox
          sy    : pos.p.oy
          obj   : pos.obj
          stage : stage

        trigger touch, pos.obj

    onPan: (e) =>
      if e.isFinal
        touch = _.first( e.changedPointers or [ e ] )
        @trigger 'touch-drag-end', @activeTouch, @normalize( touch )
        delete @activeTouch

      else
        touch = _.first( e.changedPointers or [ e ] )
        @activeTouch ?= @normalize( touch )
        @trigger 'touch-drag-change', { origin: @activeTouch, current: @normalize( touch ) }

    onPinch: (e) =>
      @pinchCenter ?= @scaleCoords e.center
      delete @pinchCenter if e.srcEvent.type is 'touchend'
      e.initialCenter = @pinchCenter

      switch e.additionalEvent
        when 'pinchout'
          @trigger 'zoom-in', e

        when 'pinchin'
          @trigger 'zoom-out', e

    onScroll: (e) =>
      console.log 'scroll', e