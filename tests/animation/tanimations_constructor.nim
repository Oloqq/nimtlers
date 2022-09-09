include ../../src/animation/anime

let fine = newAnimations({
  "idle": ivec2(0, 20),
  "death": ivec2(90, 100) }.toTable,
"death")

doAssertRaises(KeyError):
  discard newAnimations({"idle": ivec2(0, 20)}.toTable, "nonexistent")