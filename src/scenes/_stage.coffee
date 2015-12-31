class Stage
  @register: (cb) ->
    return if @instance
    Q.scene @name, (qStage) =>
      @instance = new this(qStage)
      cb?( stage )

  @load: ->
    Q.stageScene @name

  constructor: (@QStage) ->
    @setupStage()
    @applyStrategy()
    @addBackground()
    @addPlanets()

  setupStage: ->
    @QStage.add "viewport"
    @QStage.add "selectionControls"

  addBackground: ->
    @QStage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]

  addPlanets: ->
    for p in @planets
      @QStage.insert new Q.Planet(p)

  applyStrategy: ->
    for teamName, conf of (@enemyStrategem or {})
      Team[ teamName ]?.useStrategy conf.strategy

    @QStage.on 'prestep', (dt) =>
      for teamName, conf of (@enemyStrategem or {})
        Team[ teamName ].step( dt )
