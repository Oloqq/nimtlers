import boxy, opengl, windy
import animation/anime
import animation/entities
import animation/movement
import std/[times, os]

let windowSize = ivec2(1280, 800)
let window = newWindow("Windy + Boxy", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()
var entity = Entity(anime: sampleAnime(bxy, window))

var time = cpuTime()


# relocate()
entity.relocate(vec2(100, 100))
# entity.relocate(vec2(100, 100))

proc update() =
  let
    current = cpuTime()
    dt = current - time
  time = current
  entity.update(dt)

proc draw() =
  bxy.beginFrame(windowSize)

  bxy.draw(entity)

  bxy.endFrame()
  window.swapBuffers()

while not window.closeRequested:
  update()
  draw()
  pollEvents()