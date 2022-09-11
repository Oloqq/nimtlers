include ../../src/animation/anime
import ../utils

const
  curdir = currentSourcePath().parentDir()
  sheetPath = &"{curdir}/32x32-10x10.png"

let
  frameSize = ivec2(32, 32)
  animts = newAnimations({"idle": ivec2(5, 10)}.toTable, "idle")
  anime = newAnime(bx, sheetPath, frameSize, animts, "nextFrame")

assert anime.frame == 5, $anime.frame
anime.nextFrame()
assert anime.frame == 6, $anime.frame
anime.nextFrame()
assert anime.frame == 7
anime.nextFrame()
assert anime.frame == 8
anime.nextFrame()
assert anime.frame == 9
anime.nextFrame()
assert anime.frame == 10
anime.nextFrame()
assert anime.frame == 5
anime.nextFrame()