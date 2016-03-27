Quintus.TeamCollisions = (Q) ->
  defaultStrategy = Q.collision

  Q.collision = (o1, o2) ->
    masks1 = o1.p.teamCollisionMask?[ o2.className ]
    masks2 = o2.p.teamCollisionMask?[ o1.className ]
    # if masks are present AND are the same. Team Collisions between 
    # these entities can be ignored
    return if masks1? and masks2? and masks1 is masks2

    defaultStrategy o1, o2
