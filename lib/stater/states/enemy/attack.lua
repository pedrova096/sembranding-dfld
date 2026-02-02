local M = {}
M.__index = M

function M.enter(self)
  local total_time = self.meleer:get_total_time()

  self.meleer:execute()

  self:state_timer({
    delay = total_time,
    state = self.StatesEnum.Move,
    payload = self.state_payload,
  })

  go.set(self.urls.VisualSprite, "tint", vmath.vector4(1, 0.2, 0.2, 1))
end

function M.exit(self)
  go.set(self.urls.VisualSprite, "tint", vmath.vector4(1))
end

return M
