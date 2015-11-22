Q.component 'shipBuilder',

  added: ->
    @timer = setInterval @build.bind(this), @entity.p.buildRate or 1000
    # @timer = setTimeout @build.bind(this), @entity.p.buildRate or 1000

  stopBuilding: ->
    clearInterval @timer

  build: ->
    { team, x, y } = @entity.p

    coords =
      x: x,
      y: y + 100

    @entity.stage.insert new Q.Marker(coords)
    @entity.stage.insert new Q.Ship(x: x, y: y, team: team, targetXY: [coords.x, coords.y])
