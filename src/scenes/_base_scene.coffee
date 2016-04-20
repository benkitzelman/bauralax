class Scene
  @register: (cb) ->
    return if @instance
    Q.scene @name, (qStage) =>
      @instance = new this(qStage)
      cb?( stage )

  @load: ->
    def = new $.Deferred
    Q.clearStages()
    Q.stageScene @name
    # allow time for the stage to have loaded
    # TODO: figure out a more definitive way to
    # determine when a stage has loaded
    _.defer ( => def.resolve(@) )
    def