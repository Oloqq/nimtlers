import boxy
import std/[tables, strformat, enumerate]
import std/macros

const syntaxHelp = "Syntax: <animationID> <startFrame>-<endFrame> <fps> [default]"

type
  MacroError = object of Defect
  Animation* = object
    bounds*: IVec2
    fps*: int
  Animations* = object
    current*: string
    frameSequences: Table[string, Animation]

proc newAnimation*(b: IVec2, fps: int): Animation =
  return Animation(bounds: b, fps: fps)

proc newAnimations*(framesSequences: Table[string, Animation],
    starting: string): Animations =
  result.frameSequences = framesSequences
  if starting notin framesSequences:
    raise newException(KeyError, &"Initial animation not found in the animation table: {starting}")
  result.current = starting

proc switch*(self: var Animations, key: string) =
  self.current = key

proc low*(self: Animations): int =
  return self.frameSequences[self.current].bounds[0]

proc high*(self: Animations): int =
  return self.frameSequences[self.current].bounds[1]

proc fps*(self: Animations): int =
  return self.frameSequences[self.current].fps

proc frameTime*(self: Animations): float =
  return 1 / self.frameSequences[self.current].fps.float

proc animationTableEntry(key: string, l, h, fps: int): NimNode =
  result = nnkExprColonExpr.newTree(
    newLit(key),
    nnkObjConstr.newTree(
      newIdentNode("Animation"),
      nnkExprColonExpr.newTree(
        newIdentNode("bounds"),
        nnkCall.newTree(
          newIdentNode("ivec2"),
          newLit(l),
          newLit(h)
        )
      ),
      nnkExprColonExpr.newTree(
        newIdentNode("fps"),
        newLit(fps)
      )
    )
  )

proc parse_entry(root: NimNode, def: ref string): NimNode =
    proc expectKind(n: NimNode, k: NimNodeKind) =
      if n.kind != k: error(syntaxHelp, n)

    root[0].expectKind nnkIdent
    let name = $root[0]

    root[1].expectKind nnkInfix
    let infix = root[1]
    infix[0].expectKind nnkIdent
    infix[1].expectKind nnkIntLit
    let start  = infix[1].intVal.int

    infix[2].expectKind nnkCommand
    let rest = infix[2]
    rest[0].expectKind nnkIntLit
    let finish = rest[0].intVal.int

    var fps: int
    case rest[1].kind
    of nnkCommand:
      let fpsAndDef = rest[1]
      fpsAndDef[0].expectKind nnkIntLit
      fpsAndDef[1].expectKind nnkIdent
      fps = fpsAndDef[0].intVal.int
      def[] = name
    of nnkIntLit:
      fps = rest[1].intVal.int
    else:
      error("burh")

    return animationTableEntry(name, start, finish, fps)
    # Ident "idle"
    # Infix
    #   Ident "-"
    #   IntLit 0
    #   Command
    #     IntLit 20
    #     Command
    #       IntLit 20
    #       Ident "default"

proc newStringRef(s = ""): ref string =
  new(result)
  result[] = s

macro animations*(description: untyped): Animations =
  var
    entries: seq[NimNode] = @[]
    def: ref string = newStringRef()

  for i, line in enumerate(description.children):
    try:
      case line.kind:
      of nnkIdent:
        error(syntaxHelp, line)
      of nnkCommand: # multi word commands
        entries.add parse_entry(line, def)
      else:
        raise newException(MacroError, &"Animation macro bad (used a keyword?) {treeRepr line}")
    except MacroError as e:
      error(&"Animation macro line {i+1}: {e.msg}")
      return quote do: @[]

  if def[] == "":
    def[] = entries[0][0].strVal

  result = nnkStmtList.newTree(
    nnkCall.newTree(
      newIdentNode("newAnimations"),
      nnkDotExpr.newTree(
        nnkTableConstr.newTree(
          entries
        ),
        newIdentNode("toTable")
      ),
      newLit(def[])
    )
  )

# dumpTree:
#   idle 0-20 20 default
discard """
StmtList
  Command
    Ident "idle"
    Infix
      Ident "-"
      IntLit 0
      Command
        IntLit 20
        Command
          IntLit 20
          Ident "default"
"""