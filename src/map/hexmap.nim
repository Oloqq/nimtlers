import ./hex
import boxy

type Hexmap* = ref object
    size: Vec2
    tiles: seq[seq[Hex]]

proc newHexmap*(size: IVec2): Hexmap =
    result = new Hexmap
    for x in 0 ..< size.x:
        result.tiles.add(@[])
        echo x
        for y in 0 ..< size.y:
            result.tiles[x].add(hex(x, y))
            echo x, " ", y

    return result

proc draw*(self: Hexmap) =
    discard