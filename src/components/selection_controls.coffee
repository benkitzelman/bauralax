Q.component 'selectionControls',

  added: ->
    @stage = @entity
    input = new TouchInput(stage: @stage)
    input.on 'touch-drag-change', @, 'drawSelection'
    input.on 'touch-drag-end', @, 'removeSelection'
    input.on 'touch', @, 'moveShips'

  drawSelection: ({origin, current}) ->
    @selector          = @findOrCreateSelector()
    @selector.p.radius = Q.distance( origin.p.px, origin.p.py, current.p.px, current.p.py )
    @selector.p.x      = origin.p.px
    @selector.p.y      = origin.p.py

  removeSelection: ->
    @selector?.destroy()

  findOrCreateSelector: ->
    return selector if selector = _.first( Q.select("SelectionBand")?.items )
    @stage.insert( selector = new Q.SelectionBand(x:0, y:0) )
    selector

  moveShips: ({p, obj}) ->
    _.each Q.select("Ship")?.items, (ship) ->
      ship.moveTo p
