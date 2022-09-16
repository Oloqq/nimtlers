include ../../src/animation/movement
import ../utils

raise newException(IOError, "asd")

type
  TestMovable = object
    pos: Vec2
    movement: Movement
    stuff: int

block relocate:
  var m: TestMovable
  let goal = vec2(100, 100)
  m.relocate(goal)
  assert m.pos == goal

block linear1:
  var m: TestMovable
  let
    start = vec2(20, 100)
    goal = vec2(120, 100)
    time = 1.0
    step = 0.25
  m.pos = start
  m.linearMove(goal, time)
  assert m.pos == start

  m.step(step)
  echo m.pos
  assert m.pos ~= vec2(20 + 100*step, 100)
  assert false
assert false

# let
#   frameSize = ivec2(32, 32)
#   animts = animations:
#     idle 0-10 10
# let a = newAnime(bx, sheet_path, frameSize, animts)
# assert a.code == sheet_path
# let b = newAnime(bx, sheet_path, frameSize, animts, "key")
# assert b.code == "key"