components {
  id: "stage"
  component: "/main/game/stages/stages_00/stages_00.tilemap"
}
components {
  id: "controller"
  component: "/main/game/stages/stages_controller.script"
}
embedded_components {
  id: "body"
  type: "collisionobject"
  data: "collision_shape: \"/main/game/stages/stages_00/stages_00.tilemap\"\n"
  "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"ground\"\n"
  "mask: \"player\"\n"
  "locked_rotation: true\n"
  ""
}
embedded_components {
  id: "good_sprout_factory"
  type: "factory"
  data: "prototype: \"/main/game/sprouts/good_sprout/good_sprout.go\"\n"
  ""
}
embedded_components {
  id: "bad_sprout_factory"
  type: "factory"
  data: "prototype: \"/main/game/sprouts/bad_sprout/bad_sprout.go\"\n"
  ""
}