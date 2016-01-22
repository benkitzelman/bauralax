class Scene
  @register: (cb) ->
    return if @instance
    Q.scene @name, (qStage) =>
      @instance = new this(qStage)
      cb?( stage )

  @load: ->
    Q.stageScene @name

