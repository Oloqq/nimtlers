import ./hex
import boxy

type Hexmap* = ref object
    size: Vec2
    tiles: seq[seq[Hex]]

