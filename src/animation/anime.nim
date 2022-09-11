import animations
import boxy, windy
import std/tables

export animations

type
  Anime = ref object
    boxy: Boxy
    code: string
    fps: int
    frame: int
    animations: Animations

proc newAnime*(boxy: Boxy, sheet: Image, frameSize: IVec2, animations: Animations, uniqKey: string): Anime =
  result = new Anime
  result.boxy = boxy
  result.code = uniqKey
  result.frame = animations.low
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

proc nextFrame(self: Anime) =
  inc self.frame
  if self.frame > self.animations.high:
    self.frame = self.animations.low

proc update*(self: Anime, dt: float) =
  echo dt

proc draw*(bxy: Boxy, anim: Anime) =
  drawImage(bxy, anim.code & $anim.frame, pos=vec2(0, 0))
  anim.nextFrame()


proc sampleAnime*(bxy: Boxy, window: Window): Anime =
  let animts =  animations:
    idle  0-20   20 default
    death 90-100 10
  return newAnime(bxy, "data/img/anime.png", ivec2(32, 32), animts)