local M = {}
M.__index = M

local function punch_animation(url, position, duration)
  go.animate(url, "position.y", go.PLAYBACK_LOOP_PINGPONG, position.y - 2, go.EASING_OUTQUAD, duration)
end

function M.enter(self)
  local rotation = 10
  local duration = 0.3

  go.set(self.urls.Visual, "euler.z", -rotation)
  go.animate(self.urls.Visual, "euler.z", go.PLAYBACK_LOOP_PINGPONG, rotation, go.EASING_INOUTQUAD, duration)

  self.state_payload.right_position = go.get_position(self.urls.PunchRight)
  self.state_payload.left_position = go.get_position(self.urls.PunchLeft)

  punch_animation(self.urls.PunchLeft, self.state_payload.left_position, duration)
  punch_animation(self.urls.PunchRight, self.state_payload.right_position, duration)
end

function M.update(self, dt)
  local direction = self.direction
  local velocity = direction * self.stats.speed

  go.set(self.urls.Body, "linear_velocity", velocity)
end

function M.exit(self)
  go.cancel_animations(self.urls.PunchLeft, "position.y")
  go.cancel_animations(self.urls.PunchRight, "position.y")
  go.cancel_animations(self.urls.Visual, "euler.z")
  go.set(self.urls.Body, "linear_velocity", vmath.vector3())
  go.set(self.urls.PunchLeft, "position.y", self.state_payload.left_position.y)
  go.set(self.urls.PunchRight, "position.y", self.state_payload.right_position.y)
  go.set(self.urls.Visual, "euler.z", 0)
end

return M
