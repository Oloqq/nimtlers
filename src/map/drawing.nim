import ./hex
import boxy, windy

const HEXES_DEBUG* = "hexes_debug"

proc draw_full(self: Hex, layout: Layout, ctx: Context) =
    let corners = self.polygon_corners(layout)

    ctx.strokeStyle = "#FF0000"
    ctx.strokeSegment(segment(corners[0], corners[1]))
    ctx.strokeSegment(segment(corners[3], corners[4]))
    ctx.strokeStyle = "#FFFF00"
    ctx.strokeSegment(segment(corners[1], corners[2]))
    ctx.strokeSegment(segment(corners[4], corners[5]))
    ctx.strokeStyle = "#FFFFFF"
    ctx.strokeSegment(segment(corners[2], corners[3]))
    ctx.strokeSegment(segment(corners[5], corners[0]))

proc draw_partial(self: Hex, layout: Layout, ctx: Context) =
    let corners = self.polygon_corners(layout)
    ctx.strokeStyle = "#FF0000"
    # ctx.strokeSegment(segment(corners[0], corners[1]))
    ctx.strokeSegment(segment(corners[3], corners[4]))
    ctx.strokeStyle = "#FFFF00"
    # ctx.strokeSegment(segment(corners[1], corners[2]))
    ctx.strokeSegment(segment(corners[4], corners[5]))
    ctx.strokeStyle = "#FFFFFF"
    ctx.strokeSegment(segment(corners[2], corners[3]))
    # ctx.strokeSegment(segment(corners[5], corners[0]))

proc draw_hexes*(bxy: Boxy) =
    var image: Image = newImage(600, 600)
    let ctx = newContext(image)
    ctx.fillStyle = "#EE00FF"
    ctx.fillCircle(circle(vec2(0, 0), float32(5)))
    ctx.fillStyle = rgba(0, 255, 0, 255)
    ctx.strokeStyle = "#EEDD00"
    ctx.lineWidth = 5
    ctx.font = "data/font/RobotoMono-Bold.ttf"

    let layout = Layout(orientation: orientation.pointy, size: vec2(50, 50), origin: vec2(100, 100))
    var hs: seq[Hex]
    var txt: seq[string]
    hs.add hex(0, 0)
    txt.add("text1")
    hs.add hex(1, 0)
    txt.add("text2")

    for h in hs:
        let pos = h.hex_to_pixel(layout)
        ctx.fillCircle(circle(pos, float32(5)))
        ctx.fillText("bruh", pos)
        h.draw_full(layout, ctx)

    bxy.addImage(HEXES_DEBUG, image)