import boxy, opengl, windy
import animation/anime

let windowSize = ivec2(1280, 800)
let window = newWindow("Windy + Boxy", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()
var an = sampleAnime(bxy, window)

proc draw() =
    bxy.beginFrame(windowSize)

    bxy.draw(an)

    bxy.endFrame()
    window.swapBuffers()

while not window.closeRequested:
    draw()
    pollEvents()