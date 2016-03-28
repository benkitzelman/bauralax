Q.component 'teamResource',
  added: ->
    @entity.p.isTeamResource = true
    @q = new Resources @val()

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

  allowCollisionsWith: (spriteType) ->
    delete @entity.p.teamCollisionMask[ spriteType ]

  ignoreCollisionsWith: (spriteType) ->
    maskVal = @val().collisionMasks[ spriteType ]
    @entity.p.teamCollisionMask ?= {}
    @entity.p.teamCollisionMask[ spriteType ] = maskVal