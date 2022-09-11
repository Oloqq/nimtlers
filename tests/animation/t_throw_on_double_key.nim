include ../../src/animation/anime

import ../utils

const
  curdir = currentSourcePath().parentDir()
  sheetPath = &"{curdir}/32x32-10x10.png"
  SAME_KEY = "throw_on_double_key"

let
  frameSize = ivec2(32, 32)
  animts = animations:
    idle 0-10 10

discard newAnime(bx, sheetPath, frameSize, animts, SAME_KEY)

doAssertRaises(BoxyError):
  discard newAnime(bx, sheetPath, frameSize, animts, SAME_KEY)