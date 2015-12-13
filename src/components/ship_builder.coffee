Q.component 'shipBuilder',

  added: ->
    @timer = setInterval @build.bind(this), @entity.p.buildRate or 1000
    # @timer = setTimeout @build.bind(this), @entity.p.buildRate or 1000
    @_emitToCoordIndex = 0


  stopBuilding: ->
    clearInterval @timer

  nextCoords: ->
    dist = 50
    { x, y } = @entity.p
    coords = [
      { x: x + dist, y: y + dist, team: Team.RED }
      { x: x + dist, y: y + dist, team: Team.BLUE }
      { x: x - dist, y: y + dist, team: Team.BLUE }
      { x: x + dist, y: y - dist, team: Team.GREEN }
      { x: x - dist, y: y - dist, team: Team.NONE }
    ]
    coords[ @_emitToCoordIndex++ % coords.length ]


  build: ->
    { team, x, y } = @entity.p

    coords = @nextCoords()
    # @entity.stage.insert new Q.Marker(coords)
    ship = new Q.Ship(x: x, y: y, team: coords.team, targetXY: coords)
    ship.on 'reached-target', ({item, target}) ->
      ship.off 'reached-target'

      ship.moveTo({x, y})
      ship.on 'reached-target', ({item, target}) -> ship.destroy()


    @entity.stage.insert ship
