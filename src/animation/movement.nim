import boxy

type
  Movement* = ref object
    goal       : Vec2
    velocity   : Vec2
    timeToStop : float
  Movable* = concept m
    m.pos is Vec2
    m.movement is Movement

proc relocate*(self: var Movable, pos: Vec2) =
  self.pos = pos

proc step(self: var Movable, dt: float) =
  discard

proc linearMove(self: var Movable, to: Vec2, time: float) =
  discard