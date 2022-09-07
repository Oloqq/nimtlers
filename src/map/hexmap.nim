import ./hex
import ./drawing
import boxy
import strformat

type Content = object
    txt: string

type Hexmap* = ref object
    size: Vec2
    tiles: seq[seq[Hex]]
    content: seq[seq[Content]]

proc newHexmap*(size: IVec2): Hexmap =
    result = new Hexmap
    for x in 0 ..< size.x:
        result.tiles.add(@[])
        result.content.add(@[])
        for y in 0 ..< size.y:
            result.tiles[x].add(hex(x, y))
            result.content[x].add(Content(txt: &"{x}|{y}"))
            echo x, " ", y

    return result

proc render*(self: Hexmap, bxy: Boxy) =
    var image: Image = newImage(600, 600)
    let ctx = newContext(image)
    ctx.fillStyle = "#EE00FF"
    ctx.fillCircle(circle(vec2(0, 0), float32(5)))
    ctx.fillStyle = rgba(0, 255, 0, 255)
    ctx.strokeStyle = "#EEDD00"
    ctx.lineWidth = 5
    ctx.font = "data/font/RobotoMono-Bold.ttf"

    let layout = Layout(orientation: orientation.pointy, size: vec2(50, 50), origin: vec2(100, 100))
    for x, col in self.tiles:
        for y, tile in col:
            let pos = tile.hex_to_pixel(layout)
            ctx.fillText(self.content[x][y].txt, pos)
            tile.draw_full(layout, ctx)

    bxy.addImage(HEXES_DEBUG, image)

proc draw*(self: Hexmap, bxy: Boxy) =
    bxy.drawImage(HEXES_DEBUG, pos=vec2(0, 0))