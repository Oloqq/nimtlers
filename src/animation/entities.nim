import boxy
import anime
import movement

type
  Entity* = ref object of RootObj
    anime*   : Anime
    pos*      : Vec2
    movement* : Movement

method update*(self: Entity, dt: float) {.base.} =
  self.anime.update(dt)

method draw*(bx: Boxy, entity: Entity) {.base.} =
  bx.draw(entity.anime, entity.pos)

when isMainModule:
  var x = Entity(pos: vec2(0, 0), movement: new Movement)

  x.relocate(vec2(0, 0))