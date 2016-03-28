Quintus.TeamCollisions = (Q) ->
  defaultStrategy = Q.collision

  Q.collision = (o1, o2) ->
    return defaultStrategy( o1, o2 ) unless isSameTeam = o1.p.team and o2.p.team and o1.p.team is o2.p.team
    return defaultStrategy( o1, o2 ) unless hasMaskedCollision = o1.p.teamCollisionMask?[ o2.className ] or o2.p.teamCollisionMask?[ o1.className ]
    # do nothing