include ../../src/animation/anime
import ../utils

const curdir = currentSourcePath().parentDir()
const sheet_path = &"{curdir}/32x32-10x10.png"

const
  FPS: float = 10
  TILL_NEXT_FRAME: float = 1 / FPS

let
  frameSize = ivec2(32, 32)
  animts = animations:
    idle 0-10  10
    walk 11-15 20
  anim = newAnime(bx, sheet_path, frameSize, animts, "t_update")

assert anim.tillNextFrame == TILL_NEXT_FRAME
assert anim.frame == 0
anim.update(0.05)
bx.draw(anim)
assert anim.tillNextFrame == TILL_NEXT_FRAME - 0.05
assert anim.frame == 0
anim.update(0.06)
assert anim.tillNextFrame == TILL_NEXT_FRAME - 0.01
assert anim.frame == 1

anim.switch("walk")
assert anim.frame == 11
assert anim.tillNextFrame == 1.0/20.0
