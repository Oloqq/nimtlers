import boxy, windy

type
    Anime = ref object
        boxy: Boxy
        maxi: uint
        cur: uint
        code: string


proc newAnime*(boxy: Boxy, sheet: Image, frame_size: IVec2): Anime =
    result = new Anime
    result.boxy = boxy
    result.code = "bruh"

    var
        x = 0
        y = 0
        i = 0u

    while y < sheet.height:
        while x < sheet.width:
            boxy.addImage(result.code & $i, subImage(sheet, x, y, frame_size.x, frame_size.y))
            inc i
            x += frame_size.x
        x = 0
        y += frame_size.y

    result.maxi = i-1



proc draw*(bxy: Boxy, anim: Anime) =
    # bxy.drawRect(rect(50, 50, 100, 100), color(100, 100, 100))
    # bxy.drawImage("bruh", pos=vec2(0, 0))
    drawImage(bxy, anim.code & $anim.cur, pos=vec2(0, 0))
    inc anim.cur
    if anim.cur >= anim.maxi:
        anim.cur = 0


proc sampleAnime*(bxy: Boxy, window: Window): Anime =
    return newAnime(bxy, readImage("data/img/anime.png"), ivec2(32, 32))