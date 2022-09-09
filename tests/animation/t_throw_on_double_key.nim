include ../../src/animation/anime

import ../utils

const
  curdir = currentSourcePath().parentDir()
  sheetPath = &"{curdir}/32x32-10x10.png"
  SAME_KEY = "key"

let
  frameSize = ivec2(32, 32)
  animations = newAnimations({"idle": ivec2(0, 10)}.toTable, "idle")

discard newAnime(bx, sheetPath, frameSize, animations, SAME_KEY)

doAssertRaises(BoxyError):
  discard newAnime(bx, sheetPath, frameSize, animations, SAME_KEY)