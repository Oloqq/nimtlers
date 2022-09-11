include ../../src/animation/animations

let baseline = newAnimations({
  "idle": Animation(bounds: ivec2(0, 20), fps: 20),
  "death": Animation(bounds: ivec2(90, 100), fps: 10) }.toTable,
  "idle")

block basic:
  let res = animations:
    idle  0-20   20 default
    death 90-100 10
  assert baseline == res

block default_to_first:
  let res = animations:
    idle  0-20   20
    death 90-100 10
  assert baseline == res

block default_set_correctly:
  let b = newAnimations({
    "idle": Animation(bounds: ivec2(0, 20), fps: 20),
    "death": Animation(bounds: ivec2(90, 100), fps: 10) }.toTable,
    "death")
  let res = animations:
    idle  0-20   20
    death 90-100 10 default
  assert b == res
