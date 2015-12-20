Q.component 'selectionControls',

  added: ->
    @stage = @entity
    input = new TouchInput(stage: @stage)
    input.on 'touch-drag-change', @, 'drawSelection'
    input.on 'touch-drag-end', @, 'removeSelection'
    input.on 'touch', @, 'moveShips'

  drawSelection: ({origin, current}) ->
    @selector = @findOrCreateSelector()
    @selector.redraw
      radius : Q.distance( origin.p.px, origin.p.py, current.p.px, current.p.py )
      x      : origin.p.px
      y      : origin.p.py

  removeSelection: ->
    @selector?.destroy()

  findOrCreateSelector: ->
    return selector if selector = _.first( Q.select("SelectionBand")?.items )
    @stage.insert( selector = new Q.SelectionBand(x:0, y:0) )
    selector

  deselectAll: ->
    _.each Q.select("Ship")?.items, (ship) -> ship.deselect()

  moveShips: ({p, obj}) ->
    _.each Q.select("Ship")?.items, (ship) ->
      return unless ship.isSelected()
      ship.moveTo p
      ship.deselect()
