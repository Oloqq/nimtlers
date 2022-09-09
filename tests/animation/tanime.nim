include ../../src/animation/anime
import os
import strformat

const curdir = currentSourcePath().parentDir()
const sheet_path = &"{curdir}/32x32-10x10.png"
# discard readImage(sheet_path)