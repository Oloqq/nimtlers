# implementation adapted from https://www.redblobgames.com/grids/hexagons/implementation.html

import vmath
import std/bitops

type
    Hex* = object
        qrs*: IVec3
    HexEdge* = 0..5
    Point = Vec2
    Orientation = object
        f0, f1, f2, f3: float
        b0, b1, b2, b3: float
        start_angle: float
    Layout* = object
        orientation*: Orientation
        size*: Vec2
        origin*: Point

proc hex*(q, r: int32): Hex =
    return Hex(qrs: ivec3(q, r, -q-r))

proc hex*(q, r, s: int32): Hex =
    doAssert(q + r + s == 0, "Cube coordinates must sum up to 0")
    return Hex(qrs: ivec3(q, r, s))

proc q*(h: Hex): int =
    return h.qrs[0]

proc r*(h: Hex): int =
     return h.qrs[1]

proc s*(h: Hex): int =
     return h.qrs[2]

proc `==`* (a, b: Hex): bool =
    return a.qrs == b.qrs

proc `+`* (a, b: Hex): Hex =
    return Hex(qrs: a.qrs + b.qrs)

proc `-`* (a, b: Hex): Hex =
    return Hex(qrs: a.qrs - b.qrs)

proc length*(h: Hex): int =
    return int((abs(h.q) + abs(h.r) + abs(h.s)) / 2)

proc distance*(a: Hex, b: Hex): int =
    return Hex(qrs: (a.qrs - b.qrs)).length

let hex_directions = [
    hex(1, 0, -1), hex(1, -1, 0), hex(0, -1, 1),
    hex(-1, 0, 1), hex(-1, 1, 0), hex(0, 1, -1)]

proc hex_direction*(direction: HexEdge): Hex =
    return hex_directions[direction]

proc hex_neighbor*(h: Hex, direction: HexEdge): Hex =
    return h + hex_direction(direction)

proc newOrientation(f0, f1, f2, f3, b0, b1, b2, b3, start_angle: float): Orientation =
    result.f0 = f0
    result.f1 = f1
    result.f2 = f2
    result.f3 = f3
    result.b0 = b0
    result.b1 = b1
    result.b2 = b2
    result.b3 = b3
    result.start_angle = start_angle

let orientation* = (
    pointy: newOrientation(sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
        sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
        0.5),
    flat: newOrientation(3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0),
        2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0,
        0.0)
    )

proc hex_to_pixel*(self: Hex, layout: Layout): Vec2 =
    let m = layout.orientation
    return vec2(
        (m.f0 * self.q.float + m.f1 * self.r.float) * layout.size.x + layout.origin.x,
        (m.f2 * self.q.float + m.f3 * self.r.float) * layout.size.y + layout.origin.y
    )

proc pixel_to_hex*(layout: Layout, point: Vec2): Hex =
    let m = layout.orientation
    let pt = vec2((point.x - layout.origin.x) / layout.size.x, (point.y - layout.origin.y) / layout.size.y)
    let q = m.b0 * pt.x + m.b1 * pt.y;
    let r = m.b2 * pt.x + m.b3 * pt.y;

    proc hex_round(hq, hr, hs: float): Hex =
        var q = round(hq)
        var r = round(hr)
        var s = round(hs)
        var q_diff: float = abs(q - hq)
        var r_diff: float = abs(r - hr)
        var s_diff: float = abs(s - hs)
        if q_diff > r_diff and q_diff > s_diff:
            q = -r - s;
        elif (r_diff > s_diff):
            r = -q - s;
        else:
            s = -q - r;
        return hex(q.int32, r.int32, s.int32);

    return hex_round(q, r, -q - r);

proc hex_corner_offset(layout: Layout, corner: HexEdge): Vec2 =
    let size = layout.size
    let angle = (2 * PI * (layout.orientation.start_angle + float(corner)) / 6)
    return vec2(size.x * cos(angle), size.y * sin(angle))

proc polygon_corners*(self: Hex, layout: Layout, ): array[6, Vec2] =
    let center = self.hex_to_pixel(layout)
    for i in 0..5:
        result[i] = center + hex_corner_offset(layout, i)

proc to_offset_pointy_odd*(self: Hex): IVec2 =
    var col = int32(self.q + (self.r - bitand(self.r, 1)) div 2)
    var row = int32(self.r)
    return ivec2(col, row)

proc offset_to_qrs_pointy_odd*(x, y: int): Hex =
    var q = int32(x - (y - bitand(y, 1)) div 2)
    var r = int32(y)
    return hex(q, r, -q - r)

proc offset_to_qrs_pointy_odd*(xy: IVec2): Hex =
    return offset_to_qrs_pointy_odd(xy[0], xy[1])