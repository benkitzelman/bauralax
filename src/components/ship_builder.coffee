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
      { x: x + dist, y: y + dist }
      { x: x - dist, y: y + dist }
      { x: x + dist, y: y - dist }
      { x: x - dist, y: y - dist }
    ]
    coords[ @_emitToCoordIndex++ % coords.length ]


  build: ->
    { team, x, y } = @entity.p

    coords = @nextCoords()
    @entity.stage.insert new Q.Marker(coords)
    @entity.stage.insert new Q.Ship(x: x, y: y, team: team, targetXY: coords)
