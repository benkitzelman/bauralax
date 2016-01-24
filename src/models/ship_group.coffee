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

  hitPoints: ->
    _.reduce @items, ((hitPoints, ship) -> hitPoints += ship.p.hitPoints), 0

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
    return unless target
    @state "moving"
    _.each @items, (ship) ->
      ship.moveTo target

  moveNext: (target) =>
    return unless target
    @state "moving"
    _.each @items, (ship) -> ship.moveNext target

  coords: =>
    allShipCoords = _.pluck @items, 'p'

    min =
      x: _.min( allShipCoords, 'x' )?.x or 0
      y: _.min( allShipCoords, 'y' )?.y or 0

    max =
      x: _.max( allShipCoords, 'x' )?.x or 0
      y: _.max( allShipCoords, 'y' )?.y or 0

    x: (max.x - min.x) / 2
    y: (max.y - min.y) / 2

  reset: =>
    @unbindShipEvents @items
    super