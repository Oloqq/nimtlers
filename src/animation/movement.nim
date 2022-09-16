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

proc update(movement: Movement, pos: Vec2, dt: float
    ): tuple[newpos: Vec2, finished: bool] =
  movement.timeToStop -= dt
  if movement.timeToStop <= 0:
    return (movement.goal, true)
  return (pos + movement.velocity * dt, false)

proc step*(self: var Movable, dt: float) =
  if self.movement != nil:
    var finished: bool
    (self.pos, finished) = self.movement.update(self.pos, dt)
    if finished:
      self.movement = nil

# this only prepares movement, remember to call step in each frame
proc linearMove*(self: var Movable, to: Vec2, time: float) =
  self.movement = new Movement
  self.movement.goal = to
  self.movement.velocity = (to - self.pos) / time
  self.movement.timeToStop = time
