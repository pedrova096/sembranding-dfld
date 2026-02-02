local Table = require("utils.table")
local Msg = require("lib.msg")

local M = {}
M.__index = M

M.StatesEnum = {
  Idle = hash("idle"),
  Move = hash("move"),
}

M.LifeCycle = {
  [M.StatesEnum.Idle] = require("lib.stater.states.idle"),
}

M.Transitions = {
  [M.StatesEnum.Idle] = { M.StatesEnum.Move }
}

local function set_state(self, state, payload)
  self.state = state
  self.state_payload = payload or {}
  self.LifeCycle[self.state].enter(self)
end

function M:new(options)
  local self = setmetatable({}, M)
  self.urls = {
    Visual = "visual",
    VisualSprite = "visual#sprite",
    Body = "#body",
  }
  self.direction = options.direction or vmath.vector3()
  self.facing = options.facing or 1 -- 1 for right, -1 for left
  self.stats = options.stats or {}

  set_state(self, options.state or self.StatesEnum.Idle)
  return self
end

function M:is(state)
  return self.state == state
end

function M:set_facing(direction_x)
  self.facing = direction_x > 0 and 1 or -1
  sprite.set_hflip(self.urls.VisualSprite, self.facing == -1)
end

function M:set_direction(direction)
  self.direction = direction
  if self.direction.x ~= 0 then
    self:set_facing(self.direction.x)
  end
end

function M:apply_transition(state, payload)
  local transitions = self.Transitions[self.state]
  if not transitions or not Table.has_value(transitions, state) then
    print("No transition found from " .. self.state .. " to " .. state)
    return
  end

  local current_lifecycle = self.LifeCycle[self.state]

  if current_lifecycle.exit then
    current_lifecycle.exit(self)
  end

  msg.post(".", Msg.STATE_CHANGED, {
    previous_state = self.state,
    state = state,
  })

  set_state(self, state, payload)
end

function M:can_transition(state)
  local transitions = self.Transitions[self.state]
  if not transitions or not Table.has_value(transitions, state) then
    return false
  end

  return true
end

function M:update(dt)
  local current_lifecycle = self.LifeCycle[self.state]
  if current_lifecycle.update then
    current_lifecycle.update(self, dt)
  end
end

---@param options.delay number - delay in seconds
---@param options.state userdata - state to transition to
---@param options.payload table - payload to transition to
function M:state_timer(options)
  if self.current_timer then
    timer.cancel(self.current_timer)
  end

  self.current_timer = timer.delay(options.delay, false, function()
    self.current_timer = nil
    self:apply_transition(options.state, options.payload)
  end)
end

return M
