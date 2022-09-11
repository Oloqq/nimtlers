import boxy, opengl, windy
import animation/anime
import std/[times, os]

let windowSize = ivec2(1280, 800)
let window = newWindow("Windy + Boxy", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()
var an = sampleAnime(bxy, window)

var time = cpuTime()

proc update() =
  let
    current = cpuTime()
    dt = current - time
  time = current
  an.update(dt)

proc draw() =
  bxy.beginFrame(windowSize)

  bxy.draw(an)

  bxy.endFrame()
  window.swapBuffers()

while not window.closeRequested:
  update()
  draw()
  pollEvents()