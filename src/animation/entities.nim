import boxy
import anime
import movement

type
  Entity* = ref object of RootObj
    # implements movement/Movable
    anime*   : Anime
    pos*      : Vec2
    movement* : Movement

method update*(self: var Entity, dt: float) {.base.} =
  self.step(dt)
  self.anime.update(dt)

method draw*(bx: Boxy, entity: Entity) {.base.} =
  bx.draw(entity.anime, entity.pos)

when isMainModule:
  var x = Entity(pos: vec2(0, 0), movement: new Movement)

  x.relocate(vec2(0, 0))