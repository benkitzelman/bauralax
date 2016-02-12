Q.component 'selectionControls',

  added: ->
    @stage = @entity
    @input = Q.hammerTouchInput

    @input.on 'touch-drag-change', @, 'drawSelection'
    @input.on 'touch-drag-end', @, 'removeSelection'
    @input.on 'touch', @, 'moveShips'
    @input.on 'press', @, 'startBuildSite'

    @stage.on 'destroyed', @, 'destroy'

  destroy: ->
    @input.off 'touch-drag-change', @, 'drawSelection'
    @input.off 'touch-drag-end', @, 'removeSelection'
    @input.off 'touch', @, 'moveShips'

    @stage.off 'destroyed', @, 'destroy'

  drawSelection: ({origin, current}) ->
    @selector = @findOrCreateSelector()
    @selector.redraw
      radius : Q.distance( origin.p.px, origin.p.py, current.p.px, current.p.py )
      x      : origin.p.px
      y      : origin.p.py

    @selectShips()

  selectShips: ->
    _.each Q.select("Ship")?.items, (ship) =>
      if ship.teamResource?.belongsToPlayer() and @selector.isInBounds( ship )
        ship.select()
      else
        ship.deselect()

  removeSelection: ->
    @selector?.destroy()

  findOrCreateSelector: ->
    return selector if selector = _.first( Q.select("SelectionBand")?.items )
    @stage.insert( selector = new Q.SelectionBand(x:0, y:0) )
    selector

  selections: ->
    ships = _.select Q.select("Ship")?.items, (ship) -> ship.isSelected()
    new ShipGroup(ships)

  moveShips: (e) ->
    return if ( group = @selections() ).isEmpty()
    group.moveTo e.p
    group.invoke 'deselect'
    group.reset()

  startBuildSite: (e) ->
    return if ( group = @selections() ).isEmpty()
    @stage.insert( site = new Q.BuildSite(x: e.p.x, y: e.p.y) )
    site

