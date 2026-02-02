local platypus = require("platypus.platypus")

local M = setmetatable({}, { __index = platypus })
M.__index = M

local JumpStatus = {
  NotPressed = 0,
  Pressed = 1,
  LongPressed = 2,
  CoyoteMode = 3,
  BufferMode = 4,
}

local function clamp_dt(dt)
  if dt > 0.1 then return 0.016 end
  return dt
end

---@param config PlatypusEnhancedConfig
---@return PlatypusEnhancedInstance
function M.create(config)
  local jump_config = config.jump_config or {}
  jump_config.coyote_time = jump_config.coyote_time or 0.10
  jump_config.buffer_time = jump_config.buffer_time or 0.10

  config.jump_config = nil
  ---@type PlatypusEnhancedInstance
  local instance = platypus.create(config)
  -- config
  instance.jump_config = jump_config or {}

  -- public-ish state (nice for debug)
  instance.jump_state = {
    status = JumpStatus.NotPressed,
    coyote = { timer = 0, duration = jump_config.coyote_time, active = false },
    buffer = { timer = 0, duration = jump_config.buffer_time, active = false, power = nil },
  }

  local jump_state = instance.jump_state
  local coyote_state = jump_state.coyote
  local buffer_state = jump_state.buffer

  -- keep original instance methods
  local raw_update = instance.update
  local raw_jump = instance.jump
  local raw_force_jump = instance.force_jump

  -- ---------- COYOTE ----------
  local function start_coyote_timer()
    coyote_state.timer = coyote_state.duration
    coyote_state.active = true
  end

  local function cleat_coyote()
    coyote_state.active = false
    coyote_state.timer = 0
  end

  local function tick_coyote(dt, grounded, was_grounded)
    if grounded and coyote_state.active then
      cleat_coyote()
      return
    end

    if was_grounded and not coyote_state.active then
      start_coyote_timer()
      return
    end

    if coyote_state.active then
      coyote_state.timer = math.max(0, coyote_state.timer - dt)
      if coyote_state.timer == 0 then
        cleat_coyote()
      end
    end
  end

  -- Must not call raw_jump() here because it checks internal ground_contact.
  -- Use force_jump() to simulate a "late ground jump".
  local function try_coyote_jump(power)
    if coyote_state.timer <= 0
        or instance.has_ground_contact()
        or instance.has_wall_contact()
    then
      return false
    end

    raw_force_jump(power)
    coyote_state.timer = 0
    return true
  end

  -- ---------- BUFFER ----------
  local function start_buffer_timer(power)
    buffer_state.timer = buffer_state.duration
    buffer_state.power = power
    buffer_state.active = true
  end

  local function clear_buffer()
    buffer_state.timer = 0
    buffer_state.active = false
    buffer_state.power = nil
  end

  local function tick_buffer(dt)
    if buffer_state.timer > 0 then
      buffer_state.timer = math.max(0, buffer_state.timer - dt)
      if buffer_state.timer == 0 then
        clear_buffer()
      end
    end
  end

  local function try_buffer_jump(grounded)
    if not buffer_state.active then
      return false
    end

    local can_jump_now =
        grounded
        or instance.has_wall_contact()
        or coyote_state.active

    if not can_jump_now then
      return false
    end

    local power = buffer_state.power

    -- prefer native behavior when grounded/wall-contact
    if grounded or instance.has_wall_contact() then
      if instance.debug then pprint(string.format("[JUMP]=buffer power=%.2f", power)) end
      jump_state.status = JumpStatus.BufferMode
      raw_jump(power)
    else
      try_coyote_jump(power)
    end

    clear_buffer()
    return true
  end

  -- ---------- PUBLIC API ----------
  function instance.jump_pressed(power)
    assert(power, "You must provide a jump takeoff power")

    if jump_state.status == JumpStatus.NotPressed then
      jump_state.status = JumpStatus.Pressed
    end

    -- 1) try normal platypus jump first (ground/wall/double)
    local before_y = instance.velocity.y
    raw_jump(power)

    local jumped =
        instance.is_jumping()
        or instance.is_wall_jumping()
        or (instance.velocity.y ~= before_y)

    if jumped then
      clear_buffer()
      coyote_state.timer = 0 -- optional: prevents immediate "extra grace" after successful jump
      return true
    end

    -- 2) try coyote
    if try_coyote_jump(power) then
      jump_state.status = JumpStatus.CoyoteMode
      if instance.debug then pprint(string.format("[JUMP]=coyote power=%.2f", power)) end
      clear_buffer()
      return true
    end

    -- 3) buffer it
    start_buffer_timer(power)
    return false
  end

  -- Override update to tick timers + consume buffer
  function instance.update(dt)
    assert(dt, "You must provide a delta time")
    dt = clamp_dt(dt)

    local was_grounded = instance.has_ground_contact()

    raw_update(dt)

    local grounded = instance.has_ground_contact()

    -- tick timers after collisions have been resolved
    tick_coyote(dt, grounded, was_grounded)
    tick_buffer(dt)

    -- if we just became jumpable, use buffered jump
    try_buffer_jump(grounded)
  end

  return instance
end

return M
