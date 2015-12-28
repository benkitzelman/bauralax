Q.component 'shipBuilder',

  added: ->
    fn     = if Q.debug then setTimeout else setInterval
    @timer = fn @build.bind(this), @entity.p.buildRate or 1000

  stopBuilding: ->
    clearInterval @timer

  nextCoords: ->
    defaultDistance = =>
      ( @entity.asset().width * @entity.p.scale / 2 ) + ( 10  * @entity.p.scale )

    { x, y } = @entity.p

    rotation = @entity.p.shipEmitRotation or 18
    dist     = @entity.p.shipEmitDistance or defaultDistance() # hypot

    @lastAngle ?= 0
    @lastAngle += rotation

    x: x + Q.offsetX( @lastAngle, dist )
    y: y + Q.offsetY( @lastAngle, dist )

  build: ->
    { x, y } = @entity.p
    team     = @entity.teamResource.val()

    coords = @nextCoords()
    ship   = new Q.Ship(x: x, y: y, team: team, path: [ coords ])

    @entity.stage.insert ship
    @entity.trigger 'shipBuilder:shipBuilt', ship
