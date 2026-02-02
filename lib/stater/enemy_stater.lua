---@diagnostic disable: duplicate-set-field
local Stater = require("lib.stater.stater")

local M = setmetatable({}, { __index = Stater })
M.__index = M

M.StatesEnum = {
  Idle = hash("idle"),
  Move = hash("move"),
  Hurt = hash("hurt"),
  Dead = hash("dead"),
  Attack = hash("attack"),
}

M.LifeCycle = {
  [M.StatesEnum.Idle] = require("lib.stater.states.idle"),
  [M.StatesEnum.Move] = require("lib.stater.states.enemy.move"),
  [M.StatesEnum.Hurt] = require("lib.stater.states.enemy.hurt"),
  [M.StatesEnum.Attack] = require("lib.stater.states.enemy.attack"),
}

M.Transitions = {
  [M.StatesEnum.Idle] = { M.StatesEnum.Move, M.StatesEnum.Hurt },
  [M.StatesEnum.Move] = { M.StatesEnum.Idle, M.StatesEnum.Attack, M.StatesEnum.Hurt },
  [M.StatesEnum.Hurt] = { M.StatesEnum.Move },
  [M.StatesEnum.Attack] = { M.StatesEnum.Move },
}

function M:new(options)
  local self = Stater:new(options)
  setmetatable(self, M)
  self.target = options.target
  return self
end

return M
