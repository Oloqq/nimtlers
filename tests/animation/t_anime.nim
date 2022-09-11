include ../../src/animation/anime
import ../utils

const curdir = currentSourcePath().parentDir()
const sheet_path = &"{curdir}/32x32-10x10.png"

let
  frameSize = ivec2(32, 32)
  animts = animations:
    idle 0-10 10
let a = newAnime(bx, sheet_path, frameSize, animts)
assert a.code == sheet_path
let b = newAnime(bx, sheet_path, frameSize, animts, "key")
assert b.code == "key"