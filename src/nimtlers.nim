import boxy, opengl, windy
import map/hexmap

let windowSize = ivec2(1280, 800)
let window = newWindow("Windy + Boxy", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()
var map = newHexmap(ivec2(4, 5))
map.render(bxy)

proc draw() =
    bxy.beginFrame(windowSize)

    map.draw(bxy)

    bxy.endFrame()
    window.swapBuffers()

window.onButtonPress = proc(button: Button) =
    if button == MouseLeft:
        echo map.screen_to_hex(window.mousePos())


proc main() =
    while not window.closeRequested:
        draw()
        pollEvents()

when isMainModule:
    main()
