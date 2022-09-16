include ../../src/animation/movement
import ../utils

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

block no_movement_is_fine:
  var m: TestMovable
  m.step(1)

block linear_x:
  var m: TestMovable
  let
    start = vec2(20, 100)
    goal = vec2(120, 100)
    time = 1.0
  m.pos = start
  m.linearMove(goal, time)
  assert m.pos == start

  m.step(0.25)
  assert m.pos ~= vec2(20 + 100*0.25, 100)

  m.step(0.75)
  assert m.pos == goal

  m.step(1)
  assert m.pos == goal

block linear:
  var m: TestMovable
  let
    start = vec2(0, 0)
    goal = vec2(200, 100)
    time = 4.0
  m.pos = start
  m.linearMove(goal, time)
  assert m.pos == start

  m.step(1)
  assert m.pos ~= vec2(50, 25)

  m.step(1)
  assert m.pos ~= vec2(100, 50)

  m.step(2)
  assert m.pos == goal

  m.step(1)
  assert m.pos == goal