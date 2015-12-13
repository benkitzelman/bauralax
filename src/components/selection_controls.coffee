Q.component 'selectionControls',

  added: ->
    Q.touchInput.on 'touch', @, 'moveShips'

  moveShips: ({p, obj}) ->
    console.log 'TOUCHED', p.x, p.y
    _.each Q.select("Ship")?.items, (ship) -> ship.moveTo p
