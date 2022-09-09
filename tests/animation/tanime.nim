include ../../src/animation/anime
import ../utils

const curdir = currentSourcePath().parentDir()
const sheet_path = &"{curdir}/32x32-10x10.png"
# discard readImage(sheet_path)
let
  bxy = newBoxy()
  frameSize = ivec2(32, 32)
  animations = newAnimations({"idle": ivec2(0, 10)}.toTable, "idle")
  a = newAnime(bx, sheet_path, frameSize, animations)
  b = newAnime(bx, sheet_path, frameSize, animations, "key")