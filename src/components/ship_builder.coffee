Q.component 'shipBuilder',

  added: ->
    @timeSinceLastShipMS = 0
    @entity.step ?= ->
    @entity.on 'inserted', @, 'onInserted'
    @entity.on 'destroyed', @, 'stopBuilding'
    @entity.on 'step', @, 'onStep'

  onInserted: ->
    initialShips = @entity.p.startingShipCount or 0
    _.defer ( => @build() while initialShips-- )

  buildRate: ->
    @entity.p.buildRate or 1000

  onStep: (dt) ->
    return unless @entity.p.isBuilding
    @timeSinceLastShipMS += dt * 1000
    @build() if @timeSinceLastShipMS >= @buildRate()

  stopBuilding: ->
    @entity.p.isBuilding = false

  isBuilding: ->
    @entity.p.isBuilding

  startBuilding: ->
    @entity.p.isBuilding = true

  nextCoords: ->
    scale = @entity.p.scale or 1
    defaultDistance = =>
      ( @entity.width() * scale / 2 ) + ( 10  * scale )

    { x, y } = @entity.p

    rotation = @entity.p.shipEmitRotation or 18
    dist     = @entity.p.shipEmitDistance or defaultDistance() # hypot

    @lastAngle ?= 0
    @lastAngle += rotation

    x: x + Q.offsetX( @lastAngle, dist )
    y: y + Q.offsetY( @lastAngle, dist )

  build: ->
    return if (team = @entity.teamResource.val()) is Team.NONE

    { x, y } = @entity.p

    coords               = @nextCoords()
    ship                 = new Q.Ship(x: x, y: y, team: team, path: [ coords ])
    ship.builder         = @entity
    @timeSinceLastShipMS = 0

    @entity.stage.insert ship
    @entity.trigger 'shipBuilder:shipBuilt', ship
