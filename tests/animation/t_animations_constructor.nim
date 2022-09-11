include ../../src/animation/animations

discard newAnimations({
  "idle": ivec2(0, 20),
  "death": ivec2(90, 100) }.toTable,
"death")

doAssertRaises(KeyError):
  discard newAnimations({"idle": ivec2(0, 20)}.toTable, "nonexistent")