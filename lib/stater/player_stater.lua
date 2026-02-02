---@diagnostic disable: duplicate-set-field
local Stater = require("lib.stater.stater")

local M = setmetatable({}, { __index = Stater })
M.__index = M

M.StatesEnum = {
  Idle = hash("idle"),
  Move = hash("move"),
}

M.LifeCycle = {
  [M.StatesEnum.Idle] = require("lib.stater.states.player.idle"),
  [M.StatesEnum.Move] = require("lib.stater.states.player.move"),
}

M.Transitions = {
  [M.StatesEnum.Idle] = { M.StatesEnum.Move },
  [M.StatesEnum.Move] = { M.StatesEnum.Idle }
}

function M:new(options)
  local self = Stater:new(options)
  setmetatable(self, M)

  -- TODO: merge
  self.urls.PunchRight = "punch_right"
  self.urls.PunchLeft = "punch_left"
  self.LifeCycle[self.state].enter(self)
  return self
end

function M:set_facing(direction_x)
  Stater.set_facing(self, direction_x)
  if self.facing == -1 then
    go.set(self.urls.PunchRight, "position.z", 1)
    go.set(self.urls.PunchLeft, "position.z", 2)
  else
    go.set(self.urls.PunchRight, "position.z", 2)
    go.set(self.urls.PunchLeft, "position.z", 1)
  end
end

return M
