local VMath = require("utils.vmath")
local Math = require("utils.math")

---@class FollowerConfig
---@field epsilon number -- max distance to target to consider the target reached
---@field max_speed number -- max velocity of the follower
---@field acceleration number -- acceleration of the follower
---@field smooth_radius number -- radius to start easing the speed

---@class Follower
---@field config FollowerOptions
---@field state { velocity: vector3 }
local M = {}
M.__index = M

---@class FollowerOptions: FollowerConfig
---@field epsilon? number -- max distance to target to consider the target reached

---@param options FollowerOptions
---@return Follower
function M.create(options)
  local self = setmetatable({}, M)
  self.config = options
  self.config.epsilon = self.config.epsilon or 0.1
  self.state = {
    velocity = vmath.vector3(),
  }
  return self
end

function M:get_desired_velocity(distance)
  if distance >= self.config.smooth_radius then
    return self.config.max_speed
  else
    local t = distance / self.config.smooth_radius -- 0..1
    return self.config.max_speed * Math.easing_out_cubic(t)
  end
end

---@class FollowerTickOptions
---@field position vector3
---@field target_position vector3

---@param dt number
---@param options FollowerTickOptions
---@return vector3, vector3
function M:tick(dt, options)
  local current = options.position
  local target = options.target_position
  local state = self.state
  local config = self.config

  local to_target = target - current
  local distance = vmath.length(to_target)

  -- if distance > config.max_radius then
  --   current = target + vmath.normalize(to_target) * config.max_radius
  -- end

  if distance < config.epsilon then
    state.velocity = vmath.vector3()
    return target, vmath.vector3()
  end

  local desired_velocity = vmath.normalize(to_target) * self:get_desired_velocity(distance)
  local acceleration = VMath.clamp_length((desired_velocity - state.velocity) / dt, config.acceleration)

  state.velocity = VMath.clamp_length(state.velocity + acceleration * dt, config.max_speed)

  local new_position = current + state.velocity * dt
  return new_position, state.velocity
end

return M
