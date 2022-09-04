# implementation of https://www.redblobgames.com/grids/hexagons/implementation.html

import boxy, windy

const HEXES_DEBUG* = "hexes_debug"

type
    Hex* = object
        qrs*: Vec3
    HexEdge* = 0..5
    Point = Vec2
    Orientation = object
        f0, f1, f2, f3: float
        b0, b1, b2, b3: float
        start_angle: float
    Layout* = object
        orientation: Orientation
        size: Vec2
        origin: Point

proc hex*(q, r: float): Hex =
    return Hex(qrs: vec3(q, r, -q-r))

proc hex*(q, r, s: float): Hex =
    doAssert(q + r + s == 0, "Cube coordinates must sum up to 0")
    return Hex(qrs: vec3(q, r, s))

proc q*(h: Hex): float =
    return h.qrs[0]

proc r*(h: Hex): float =
     return h.qrs[1]

proc s*(h: Hex): float =
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

proc hex_to_pixel*(layout: Layout, h: Hex): Vec2 =
    let m = layout.orientation
    return vec2(
        (m.f0 * h.q + m.f1 * h.r) * layout.size.x + layout.origin.x,
        (m.f2 * h.q + m.f3 * h.r) * layout.size.y + layout.origin.y
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
        return hex(q, r, s);

    return hex_round(q, r, -q - r);

proc hex_corner_offset(layout: Layout, corner: HexEdge): Vec2 =
    let size = layout.size
    let angle = (2 * PI * (layout.orientation.start_angle + float(corner)) / 6)
    return vec2(size.x * cos(angle), size.y * sin(angle))

proc polygon_corners(layout: Layout, h: Hex): array[6, Vec2] =
    let center = hex_to_pixel(layout, h)
    for i in 0..5:
        result[i] = center + hex_corner_offset(layout, i)

proc draw_hex(ctx: Context, layout: Layout, h: Hex): void =
    let corners = polygon_corners(layout, h)
    echo corners

    ctx.strokeStyle = "#FF0000"
    ctx.strokeSegment(segment(corners[0], corners[1]))
    ctx.strokeStyle = "#FFFF00"
    ctx.strokeSegment(segment(corners[1], corners[2]))
    ctx.strokeStyle = "#FFFFFF"
    ctx.strokeSegment(segment(corners[2], corners[3]))
    ctx.strokeStyle = "#00FF00"
    ctx.strokeSegment(segment(corners[3], corners[4]))
    ctx.strokeStyle = "#00FFFF"
    ctx.strokeSegment(segment(corners[4], corners[5]))
    ctx.strokeStyle = "#FF00FF"
    ctx.strokeSegment(segment(corners[5], corners[0]))

proc draw_hexes*(bxy: Boxy) =
    var image: Image = newImage(600, 600)
    let ctx = newContext(image)
    ctx.fillStyle = rgba(0, 255, 0, 255)
    ctx.strokeStyle = "#EEDD00"
    ctx.lineWidth = 5

    let layout = Layout(orientation: orientation.flat, size: vec2(50, 50), origin: vec2(100, 100))
    let h = hex(0, 0, 0)
    let pos = hex_to_pixel(layout, h)
    ctx.fillCircle(circle(pos, float32(5)))
    draw_hex(ctx, layout, h)

    bxy.addImage(HEXES_DEBUG, image)

