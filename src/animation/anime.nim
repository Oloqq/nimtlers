import boxy, windy
import std/tables

type
    Animations* = object
        current: IVec2
        frameSequences: Table[string, IVec2]
    Anime = ref object
        boxy: Boxy
        frame: int
        code: string
        animations: Animations

proc newAnimations*(framesSequences: Table[string, IVec2], starting: string): Animations =
    result.frameSequences = framesSequences
    result.current = framesSequences[starting]

proc newAnime*(boxy: Boxy, sheet: Image, frameSize: IVec2, animations: Animations, uniqKey: string): Anime =
    result = new Anime
    result.boxy = boxy
    result.code = uniqKey
    result.animations = animations

    var
        x = 0
        y = 0
        i = 0

    while y < sheet.height:
        while x < sheet.width:
            boxy.addImage(result.code & $i, subImage(sheet, x, y, frameSize.x, frameSize.y))
            inc i
            x += frameSize.x
        x = 0
        y += frameSize.y

proc newAnime*(boxy: Boxy, source: string, frameSize: IVec2, animations: Animations, uniqKey: string): Anime =
    return newAnime(boxy, readImage(source), frameSize, animations, uniqKey)

proc newAnime*(boxy: Boxy, source: string, frameSize: IVec2, animations: Animations): Anime =
    return newAnime(boxy, readImage(source), frameSize, animations, source)

proc draw*(bxy: Boxy, anim: Anime) =
    drawImage(bxy, anim.code & $anim.frame, pos=vec2(0, 0))
    inc anim.frame
    if anim.frame >= anim.animations.current[1]:
        anim.frame = anim.animations.current[0]


proc sampleAnime*(bxy: Boxy, window: Window): Anime =
    let animations = newAnimations({ "idle": ivec2(0, 20), "death": ivec2(90, 100) }.toTable, "death")
    return newAnime(bxy, "data/img/anime.png", ivec2(32, 32), animations)