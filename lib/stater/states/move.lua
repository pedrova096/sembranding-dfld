local M = {}
M.__index = M

function M.enter(self)
  local rotation = 10
  local duration = 0.3

  go.set(self.urls.Visual, "euler.z", -rotation)
  go.animate(self.urls.Visual, "euler.z", go.PLAYBACK_LOOP_PINGPONG, rotation, go.EASING_INOUTQUAD, duration)
end

function M.update(self, dt)
  local direction = self.direction
  local velocity = direction * self.stats.speed

  go.set(self.urls.Body, "linear_velocity", velocity)
end

function M.exit(self)
  go.cancel_animations(self.urls.Visual, "euler.z")
  go.set(self.urls.Visual, "euler.z", 0)
end

return M
