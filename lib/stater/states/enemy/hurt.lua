local M = {}
M.__index = M

function M.enter(self)
  local duration = 0.175

  self.stats.health = self.stats.health - 1

  local next_state = self.StatesEnum.Move
  if self.stats.health <= 0 then
    next_state = self.StatesEnum.Dead
  end

  self:state_timer({
    delay = duration,
    state = next_state,
  })

  go.set(self.urls.VisualSprite, "tint", vmath.vector4(0.5, 0.5, 0.5, 1))
end

function M.exit(self)
  go.set(self.urls.VisualSprite, "tint", vmath.vector4(1))
end

return M
