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

local Game = {
  SET_MAP_BOUNDS = hash("set_map_bounds"),
}

local Kameha = {
  MOVE_TRIGGER = hash("move_trigger"),
}

local Main = {
  GAME_OVER = hash("game_over"),
  NEW_GAME = hash("new_game")
}

local Meleer = {
  PREPARE_ATTACK = hash("prepare_attack"),
  RUN_ATTACK = hash("run_attack"),
  END_ATTACK = hash("end_attack"),
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
  Game = Game,
  Kameha = Kameha,
  Main = Main,
  Meleer = Meleer,
  ---
  HIDE_ELEMENT = hash("hide_element"),
  SHOW_ELEMENT = hash("show_element"),
  PROXY_UNLOADED = hash("proxy_unloaded"),
  PROXY_LOADED = hash("proxy_loaded"),
  APPLY_DAMAGE = hash("apply_damage"),
  COLLISION_RESPONSE = hash("collision_response"),
  STATE_CHANGED = hash("state_changed"),
}
