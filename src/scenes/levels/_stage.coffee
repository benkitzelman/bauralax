class Stage extends Scene
  @type = 'game'

  constructor: (@QStage) ->
    @setupStage()
    @applyStrategy()
    @addBackground()
    @addPlanets()
    window.setVP = (@viewportTarget) =>

  planetsBounds: (padding = 0)->
    bounds =
      min:
        x: _.reduce( @planets, ((min, p) -> min = _.min [ p.x, min ]), @planets[0].x )
        y: _.reduce( @planets, ((min, p) -> min = _.min [ p.y, min ]), @planets[0].y )

      max:
        x: _.reduce( @planets, ((max, p) -> max = _.max [ p.x, max ]), @planets[0].x )
        y: _.reduce( @planets, ((max, p) -> max = _.max [ p.y, max ]), @planets[0].y )

    _.extend {}, bounds,
      width:  bounds.max.x - bounds.min.x + padding * 2
      height: bounds.max.y - bounds.min.y + padding * 2

  autoScale: ->
    { width, height } = @planetsBounds 150
    scaleWidth     = _.min [ 1, Q.cssWidth / width ]
    scaleHeight    = _.min [ 1, Q.cssHeight / height ]

    _.min [ scaleWidth, scaleHeight ]

  autoCenter: ->
    { min, width, height } = @planetsBounds()
    x: min.x + (width / 2)
    y: min.y + (height / 2)

  setupStage: ->
    @QStage.add "viewport"
    @QStage.add "selectionControls"
    @QStage.on "step", @, 'onStep'
    Q.hammerTouchInput.on "press", @onPress
    Q.hammerTouchInput.on 'zoom-out', @onZoomOut
    Q.hammerTouchInput.on 'zoom-in', @onZoomIn

    # starting coords
    { x, y } = @autoCenter()
    @QStage.viewport.scale = @autoScale()
    @QStage.viewport.centerOn x, y

    # zoom to
    @zoomTo
      scale  : @viewport?.scale or @autoScale()
      coords : @viewport?.coords or @autoCenter()

    Hud.instance().show()
    # @QStage.collide = (obj, options) ->
    #   debugger
      #apply the collision mask so friendly ships dont collide

  zoomTo: (@viewportTarget) ->
    @autoZoom = true
    @on 'viewport-target-reached', @, =>
      @autoZoom = false
      console.log 'zoomed'

  addBackground: =>
    @QStage.insert(new Q.Background)
    @QStage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]

  addPlanets: =>
    for p in @planets
      @QStage.insert new Q.Planet(p)

  applyStrategy: =>
    for teamName, conf of (@enemyStrategem or {})
      Team[ teamName ]?.useStrategy conf.strategy

    @QStage.on 'prestep', (dt) =>
      for teamName, conf of (@enemyStrategem or {})
        Team[ teamName ].step( dt )

  transitionTo: (Stage) =>
    fadeables = Q.select('Planet').items.concat Q.select('Star').items
    @QStage.on 'step', (dt) =>
      _.each fadeables, (sprite) ->
        sprite.p.opacity = _.max [ 0, sprite.p.opacity - 0.02 ]

      return unless _.all( fadeables, (sprite) -> sprite.p.opacity is 0 )
      _.invoke fadeables, 'destroy'
      _.each Q.select('Ship').items, (ship) ->
        _.delay (-> ship.explode()), Q.random(0, 500)

      @QStage.off 'step'

      _.delay (->
        Q.clearStages()
        Stage.load()
      ), 1000

  onStep: (dt) ->
    stepCoords = =>
      { x, y } = @viewportTarget?.coords or {}
      return unless x? and y?

      vCX = @QStage.viewport.x + ( Q.width / 2 / @QStage.viewport.scale )
      vCY = @QStage.viewport.y + ( Q.height / 2 / @QStage.viewport.scale )

      maxStepDistance = 10
      targetAngle     = Q.angle vCX, vCY, x, y
      tripDistance    = Q.distance vCX, vCY, x, y
      stepDistance    = _.min [ dt * 500, tripDistance, maxStepDistance ] # step hypotenuse

      xDistance       = Q.offsetX targetAngle, stepDistance
      yDistance       = Q.offsetY targetAngle, stepDistance

      center =
        x: vCX + ( xDistance * Q.axis( targetAngle ).x )
        y: vCY + ( yDistance * Q.axis( targetAngle ).y )

      @QStage.viewport.centerOn center.x, center.y

    stepScale = =>
      return unless scale = @viewportTarget?.scale
      return if scale is @QStage.viewport.scale

      maxSpeed       = 0.05
      remainingScale = Math.abs( @QStage.viewport.scale - scale )
      scaleStep      =  _.min [ dt, remainingScale, maxSpeed ]

      scaleStep *= -1 if @QStage.viewport.scale > scale
      @QStage.viewport.scale += scaleStep

    atTarget = =>
      { x, y, scale } = @QStage.viewport
      vCX = x + ( Q.width / 2 / @QStage.viewport.scale )
      vCY = y + ( Q.height / 2 / @QStage.viewport.scale )

      @viewportTarget?.scale is scale and @viewportTarget?.coords?.x is vCX and @viewportTarget?.coords?.y is vCY

    #--

    stepCoords()
    stepScale()
    return unless atTarget()

    @trigger 'viewport-target-reached', @viewportTarget
    delete @viewportTarget

  zoomIncrementFor: (velocity) ->
    _.max [ 0.15, Math.abs( velocity ) ]

  onZoomOut: (e) =>
    @viewportTarget ?=
      scale: _.max [ 0.2, @QStage.viewport.scale - @zoomIncrementFor( e.velocity ) ]
      coords: e.initialCenter

  onZoomIn: (e) =>
    @viewportTarget ?=
      scale: _.min [ 3, @QStage.viewport.scale + @zoomIncrementFor( e.velocity ) ]
      coords: e.initialCenter

  onPress: (e) =>
    props =
      x      : e.p.x
      y      : e.p.y
      team   : Game.instance.playerTeam

    Q.ShipYard.createWith( props ).on( @QStage )


