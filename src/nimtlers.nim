import boxy, opengl, windy
import hexes

let windowSize = ivec2(1280, 800)

let window = newWindow("Windy + Boxy", windowSize)
makeContextCurrent(window)

loadExtensions()

let bxy = newBoxy()

# Load the images.
# bxy.addImage("bg", readImage("data/img/cat.jpg"))

var frame: int
draw_hexes(bxy)


# Called when it is time to draw a new frame.
proc display() =
  # Clear the screen and begin a new frame.
  bxy.beginFrame(windowSize)

  # bxy.drawImage("bg", rect = rect(vec2(0, 0), windowSize.vec2))

  bxy.drawImage(HEXES_DEBUG, pos = vec2(0, 0))

  # End this frame, flushing the draw commands.
  bxy.endFrame()
  # Swap buffers displaying the new Boxy frame.
  window.swapBuffers()
  inc frame



while not window.closeRequested:
  display()
  pollEvents()