class ShipGroup extends Collection
  add: (ships = []) =>
    ships = _.select _.flatten([ ships ]), (s) ->
      s.isA('Ship') and not s.isDestroyed

    @bindShipEvents ships
    super ships

  state: (val) =>
    if val
      @_state = val
    else
      @_state or 'waiting'

  remove: (ships = []) =>
    @unbindShipEvents ships
    super ships

  bindShipEvents: (ships = []) =>
    ships = _.flatten [ ships ]
    _.each ships, (s) =>
      s.on 'destroyed', @, 'remove'

  unbindShipEvents: (ships = []) =>
    ships = _.flatten [ ships ]
    _.each ships, (s) =>
      s.off 'destroyed', @, 'remove'

  moveTo: (target) =>
    @state "moving"
    _.each @items, (ship) ->
      ship.moveTo target

  reset: =>
    @unbindShipEvents @items
    super