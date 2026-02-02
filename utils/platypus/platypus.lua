local platypus = require("platypus.platypus")
local ManualTimer = require("utils.manual_timer")

local M = setmetatable({}, { __index = platypus })
M.__index = M

local function clamp_dt(dt)
  if dt > 0.1 then return 0.016 end
  return dt
end

local JumpStatus = {
  None = 0,
  Jump = 1,
  Landed = 2,
  CoyoteJump = 3,
  BufferingJump = 4,
  BufferJump = 5,
}

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
    status = JumpStatus.None,
    coyote = { timer = ManualTimer.create(jump_config.coyote_time) },
    buffer = { timer = ManualTimer.create(jump_config.buffer_time), power = nil },
  }

  local jump_state = instance.jump_state
  local coyote_state = jump_state.coyote
  local buffer_state = jump_state.buffer

  -- keep original instance methods
  local raw_update = instance.update
  local raw_jump = instance.jump
  local raw_force_jump = instance.force_jump

  -- ---------- COYOTE ----------
  local function tick_coyote(dt, grounded, was_grounded)
    if was_grounded and not grounded and not coyote_state.timer:is_active() then
      if instance.debug then pprint("[COYOTE_JUMP]=start") end
      coyote_state.timer:start()
      return
    end

    if grounded and coyote_state.timer:is_active() then
      if instance.debug then pprint("[COYOTE_JUMP]=clear_grounded ") end
      coyote_state.timer:clear()
      return
    end

    if not coyote_state.timer:is_active() then return end

    coyote_state.timer:tick(dt)
    if instance.debug and not coyote_state.timer:is_active() then pprint("[COYOTE_JUMP]=clear_done") end
  end

  -- Must not call raw_jump() here because it checks internal ground_contact.
  -- Use force_jump() to simulate a "late ground jump".
  local function try_coyote_jump(power)
    if not coyote_state.timer:is_active()
        or instance.has_ground_contact()
        or instance.has_wall_contact()
    then
      return false
    end

    raw_force_jump(power)
    if instance.debug then
      pprint(string.format("[JUMP]=coyote power=%.2f at_progress=%.2f", power,
        coyote_state.timer:get_progress()))
      pprint("[COYOTE_JUMP]=clear_consumed")
    end
    coyote_state.timer:clear()
    return true
  end

  -- ---------- BUFFER ----------

  local function start_buffer_jump(power)
    if instance.debug then pprint("[BUFFER_JUMP]=start") end
    buffer_state.timer:start()
    buffer_state.power = power
  end

  local function clear_buffer_jump()
    buffer_state.timer:clear()
    buffer_state.power = nil
  end

  local function tick_buffer(dt)
    local was_active = buffer_state.timer:is_active()
    buffer_state.timer:tick(dt)
    if instance.debug and not buffer_state.timer:is_active() and was_active then pprint("[BUFFER_JUMP]=clear_done") end
  end

  local function try_buffer_jump(grounded)
    if not buffer_state.timer:is_active() then return false end

    local can_jump_now =
        grounded
        or instance.has_wall_contact()
        or coyote_state.timer:is_active()

    if not can_jump_now then
      return false
    end

    local power = buffer_state.power or 0

    -- prefer native behavior when grounded/wall-contact
    if grounded or instance.has_wall_contact() then
      jump_state.status = JumpStatus.BufferJump
      if instance.debug then
        pprint(string.format("[JUMP]=buffer power=%.2f at_progress=%.2f", power,
          buffer_state.timer:get_progress()))
      end
      raw_jump(power)
    end

    if instance.debug and buffer_state.timer:is_active() then pprint("[BUFFER_JUMP]=clear_consumed") end
    clear_buffer_jump()
    return true
  end

  -- ---------- PUBLIC API ----------
  function instance.jump_pressed(power)
    assert(power, "You must provide a jump takeoff power")
    if jump_state.status == JumpStatus.Landed then
      return false
    end

    raw_jump(power)

    if instance.is_jumping() and jump_state.status == JumpStatus.None then
      jump_state.status = JumpStatus.Jump
    end

    local jumped =
        instance.is_jumping()
        or instance.is_wall_jumping()
    -- or (instance.velocity.y ~= before_y)

    if jumped then
      clear_buffer_jump()
      coyote_state.timer:clear() -- optional: prevents immediate "extra grace" after successful jump
      return true
    end

    -- 2) try coyote
    if try_coyote_jump(power) then
      jump_state.status = JumpStatus.CoyoteJump
      clear_buffer_jump()
      return true
    end

    if jump_state.status == JumpStatus.None then
      jump_state.status = JumpStatus.BufferingJump
      -- 3) buffer it
      start_buffer_jump(power)
    end

    return false
  end

  function instance.jump_released()
    if jump_state.status == JumpStatus.Jump then
      instance.abort_jump()
    end

    jump_state.status = JumpStatus.None
  end

  local function check_jump_status(grounded)
    if grounded and jump_state.status == JumpStatus.Jump or jump_state.status == JumpStatus.BufferingJump then
      jump_state.status = JumpStatus.Landed
    end
  end

  -- Override update to tick timers + consume buffer
  function instance.update(dt)
    assert(dt, "You must provide a delta time")
    dt = clamp_dt(dt)

    local was_grounded = instance.has_ground_contact()

    raw_update(dt)

    local grounded = instance.has_ground_contact()

    check_jump_status(grounded)

    -- tick timers after collisions have been resolved
    tick_coyote(dt, grounded, was_grounded)
    tick_buffer(dt)

    -- if we just became jumpable, use buffered jump
    try_buffer_jump(grounded)
  end

  return instance
end

return M
