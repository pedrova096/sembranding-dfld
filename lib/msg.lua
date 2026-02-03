local Player = {
  MOVE_TRIGGER = hash("move_trigger"),
  STOP_MOVE = hash("stop_move"),
  ACTION_A_PRESS = hash("action_a_press"),
  ACTION_A_RELEASE = hash("action_a_release"),
  ACTION_B_PRESS = hash("action_b_press"),
  ACTION_B_RELEASE = hash("action_b_release"),
  UPDATE_HEALTH_STATUS = hash("update_health_status"),
  PUNCH_HIT = hash("punch_hit"),
}

local Seeder = {
  FOLLOW_PLAYER = hash("follow_player"),
}

local Game = {
  SET_MAP_BOUNDS = hash("set_map_bounds"),
  SEEDABLE_CONTACT = hash("seedable_contact"),
  SEEDABLE_CONTACT_END = hash("seedable_contact_end"),
}

local Main = {
  GAME_OVER = hash("game_over"),
  NEW_GAME = hash("new_game")
}

local Camera = {
  CAMERA_FOLLOW = hash("camera_follow"),
  CAMERA_UNFOLLOW = hash("camera_unfollow"),
  SHAKE = hash("camera_shake"),
  SHAKE_INTERRUPT = hash("camera_shake_interrupt"),
}


return {
  Player = Player,
  Camera = Camera,
  Seeder = Seeder,
  Game = Game,
  Main = Main,
  ---
  HIDE_ELEMENT = hash("hide_element"),
  SHOW_ELEMENT = hash("show_element"),
  PROXY_UNLOADED = hash("proxy_unloaded"),
  PROXY_LOADED = hash("proxy_loaded"),
  APPLY_DAMAGE = hash("apply_damage"),
  COLLISION_RESPONSE = hash("collision_response"),
  STATE_CHANGED = hash("state_changed"),
}
