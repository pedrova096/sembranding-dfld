local M = {}
M.__index = M

function M.enter(self)
  local duration = 0.3
  self:state_timer({
    delay = duration,
    state = self.StatesEnum.Move,
    payload = self.state_payload,
  })
  go.set(self.urls.VisualSprite, "tint", vmath.vector4(0.5, 0.5, 0.5, 1))
end

function M.exit(self)
  go.set(self.urls.VisualSprite, "tint", vmath.vector4(1))
end

return M
