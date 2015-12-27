Q.component 'teamResource',

  added: ->
    @entity.p.isTeamResource = true

  val: (v) ->
    if v
      @entity.p.team = v
    else
      @entity.p.team or Team.none

  isTeamResource: (sprite) ->
    sprite.p.isTeamResource

  isTeammate: (sprite) ->
    return false unless team = sprite.teamResource?.val()
    team is @val()

  belongsToPlayer: ->
    G.playerTeam is @val()
