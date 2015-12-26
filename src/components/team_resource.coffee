Q.component 'teamResource',

  added: ->
    entity = @entity
    entity.p.teamResource = true

    fn =
      team: ->
        entity.p.team or Team.none

      isTeamResource: (sprite) ->
        sprite.p.teamResource

      isTeammate: (sprite) ->
        return false unless team = sprite.team?()
        team is fn.team()

      belongsToPlayer: ->
        G.playerTeam is @team()

    _.extend entity, fn




