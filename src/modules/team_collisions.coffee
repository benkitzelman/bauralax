Quintus.TeamCollisions = (Q) ->
  defaultStrategy = Q.collision
  Q.collision = (o1, o2) ->
    return if o1?.p?.teamCollisionMask and o1.p.teamCollisionMask is o2?.p?.teamCollisionMask
    defaultStrategy o1, o2
