components {
  id: "controller"
  component: "/main/game/player/seeder/seeder_controller.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ball\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/player/player.atlas\"\n"
  "}\n"
  ""
}
