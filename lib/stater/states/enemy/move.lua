local DefaultIdle = require("lib.stater.states.move")
local Math = require("utils.math")

local M = {}
M.__index = M

local function init_wander(self)
  self.state_payload.wander = {
    current_angle = 0,
    target_angle = nil,
    timer = 0,
    duration = self.state_payload.wander_duration or 0.5,
    max_angle = self.state_payload.wander_max_angle or 20,
  }
end

local function wander_pipe(self, dt)
  local wander = self.state_payload.wander
  wander.timer = wander.timer - dt

  if wander.timer <= 0 then
    wander.target_angle = (math.random() * 2 - 1) * wander.max_angle
    wander.timer = wander.duration
  end

  local lerp_progress = wander.timer / wander.duration
  lerp_progress = math.sin(lerp_progress * math.pi) -- smooth lerp
  wander.current_angle = Math.lerp(wander.current_angle, wander.target_angle, lerp_progress)
  wander.rads = math.rad(wander.current_angle)
end

function M.enter(self)
  DefaultIdle.enter(self)
  init_wander(self)
end

function M.update(self, dt)
  wander_pipe(self, dt)

  local position = go.get_position()
  local target_position = go.get_position(self.target)
  local delta = target_position - position
  local direction = vmath.normalize(delta)


  direction = vmath.rotate(vmath.quat_rotation_z(self.state_payload.wander.rads), direction)
  self:set_direction(direction)
  DefaultIdle.update(self, dt)
end

function M.exit(self)
  DefaultIdle.exit(self)
end

return M
