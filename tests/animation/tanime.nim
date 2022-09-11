include ../../src/animation/anime
import ../utils

const curdir = currentSourcePath().parentDir()
const sheet_path = &"{curdir}/32x32-10x10.png"
# discard readImage(sheet_path)
let
  frameSize = ivec2(32, 32)
  animts = newAnimations({"idle": ivec2(0, 10)}.toTable, "idle")
let b = newAnime(bx, sheet_path, frameSize, animts, "key")
assert b.code == "key"
let a = newAnime(bx, sheet_path, frameSize, animts)
assert a.code == sheet_path