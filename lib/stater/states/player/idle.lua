local DefaultIdle = require("lib.stater.states.idle")

local M = {}
M.__index = M

local function punch_animation(url, position, duration)
  go.animate(url, "position.y", go.PLAYBACK_LOOP_PINGPONG, position.y - 2, go.EASING_OUTQUAD, duration)
end

function M.enter(self)
  DefaultIdle.enter(self)
  local duration = 0.3

  self.state_payload.right_position = go.get_position(self.urls.PunchRight)
  self.state_payload.left_position = go.get_position(self.urls.PunchLeft)

  punch_animation(self.urls.PunchLeft, self.state_payload.left_position, duration)
  punch_animation(self.urls.PunchRight, self.state_payload.right_position, duration)
end

function M.exit(self)
  DefaultIdle.exit(self)
  go.cancel_animations(self.urls.PunchRight, "position.y")
  go.cancel_animations(self.urls.PunchLeft, "position.y")
  go.set(self.urls.PunchRight, "position.y", self.state_payload.right_position.y)
  go.set(self.urls.PunchLeft, "position.y", self.state_payload.left_position.y)
end

return M
