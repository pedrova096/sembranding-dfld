-- manual_timer.lua
-- Simple manual timer for buffer and state management

---@class ManualTimer
---@field duration number
---@field remaining number
---@field active boolean
local M = {}
M.__index = M

---Create a new timer
---@param duration number -- Duration in seconds
---@return ManualTimer
function M.create(duration)
  local self = setmetatable({}, M)
  self.duration = duration
  self.remaining = 0
  self.active = false
  return self
end

---Start the timer
function M:start()
  self.remaining = self.duration
  self.active = true
end

---Tick the timer by delta time
---@param dt number -- Delta time in seconds
function M:tick(dt)
  if not self.active then
    return
  end

  self.remaining = math.max(0, self.remaining - dt)
  if self.remaining <= 0 then
    self.active = false
  end
end

---Clear the timer
function M:clear()
  self.remaining = 0
  self.active = false
end

---Check if timer is active
---@return boolean
function M:is_active()
  return self.active
end

---Get remaining time
---@return number
function M:get_remaining()
  return self.remaining
end

---Get progress
---@return number
function M:get_progress()
  return (self.duration - self.remaining) / self.duration
end

---Set the duration
---@param duration number
function M:set_duration(duration)
  self.duration = duration
end

return M
