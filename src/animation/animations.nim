import boxy
import std/[tables, strformat]

type
  Animations* = object
    current: string
    frameSequences: Table[string, IVec2]

proc newAnimations*(framesSequences: Table[string, IVec2], starting: string): Animations =
  result.frameSequences = framesSequences
  if starting notin framesSequences:
    raise newException(KeyError, &"Initial animation not found in the animation table: {starting}")
  result.current = starting

proc low*(self: Animations): int32 =
  return self.frameSequences[self.current][0]

proc high*(self: Animations): int32 =
  return self.frameSequences[self.current][1]