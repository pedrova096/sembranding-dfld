components {
  id: "controller"
  component: "/main/game/sprouts/good_sprout/good_sprout_controller.script"
}
embedded_components {
  id: "collision_object"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"seed_ground\"\n"
  "mask: \"player\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "      y: -2.0\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "  }\n"
  "  data: 22.0\n"
  "  data: 2.0\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
embedded_components {
  id: "model"
  type: "model"
  data: "mesh: \"/main/game/sprouts/sprout_area.dae\"\n"
  "name: \"{{NAME}}\"\n"
  "materials {\n"
  "  name: \"default\"\n"
  "  material: \"/main/materials/sprout.material\"\n"
  "  textures {\n"
  "    sampler: \"sprite\"\n"
  "    texture: \"/assets/tiles/good_sprout.png\"\n"
  "  }\n"
  "}\n"
  ""
  position {
    y: 12.0
  }
}
