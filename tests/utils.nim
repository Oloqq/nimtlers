import os, strformat
import boxy, windy, opengl

export os, strformat, boxy

let windowSize = ivec2(1280, 800)
let window* = newWindow("Testing window should be invisible", windowSize, visible=false)
makeContextCurrent(window)
loadExtensions()

let bx* = newBoxy()