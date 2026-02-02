local M = {}
M.__index = M

function M.enter(self)
  local duration = .3

  go.animate(self.urls.Visual, "scale.y", go.PLAYBACK_LOOP_PINGPONG, 1.1, go.EASING_OUTQUAD, duration, 0)
end

function M.exit(self)
  go.cancel_animations(self.urls.Visual, "scale.y")
  go.set(self.urls.Visual, "scale.y", 1)
end

return M
