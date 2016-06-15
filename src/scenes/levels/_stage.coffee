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
    @viewportTarget = 
      scale: @viewport?.scale or @autoScale()
      coords: @viewport?.coords or @autoCenter()

    console.log 'Start:', x, y, 'zoom to:', @viewportTarget.coords
    Hud.instance().show()
    # @QStage.collide = (obj, options) ->
    #   debugger
      #apply the collision mask so friendly ships dont collide

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

      vX = @QStage.viewport.x + ( Q.width / 2 / @QStage.viewport.scale )
      vY = @QStage.viewport.y + ( Q.height / 2 / @QStage.viewport.scale )

      maxStepDistance = 5
      targetAngle     = Q.angle vX, vY, x, y
      tripDistance    = Q.distance vX, vY, x, y
      stepDistance    = _.min [ dt, tripDistance, maxStepDistance ] # step hypotenuse

      xDistance       = Q.offsetX targetAngle, stepDistance
      yDistance       = Q.offsetY targetAngle, stepDistance

      coords =
        x: ( xDistance * Q.axis( targetAngle ).x ) + vX
        y: ( yDistance * Q.axis( targetAngle ).y ) + vY

      console.log 'stepping from:', vX, vY, 'to:', coords, targetAngle, Q.axis( Q.normalizeAngle targetAngle )
      @QStage.viewport.centerOn coords.x, coords.y

    stepScale = =>
      return unless scale = @viewportTarget?.scale
      return if scale is @QStage.viewport.scale

      maxSpeed       = 0.02
      remainingScale = Math.abs( @QStage.viewport.scale - scale )
      scaleStep      = _.min [ dt, remainingScale, maxSpeed ]

      scaleStep *= -1 if @QStage.viewport.scale > scale
      @QStage.viewport.scale += scaleStep
    #--

    stepScale()
    stepCoords()
    delete @viewportTarget if @viewportTarget?.scale is @QStage.viewport.scale

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


