local Msg = require("lib.msg")
local Pooler = require("lib.pooler")

local M = {}
M.__index = M

function M.new(factory_url, pool_size)
  local instance = setmetatable({}, M)

  instance.factory_url = factory_url
  instance.pool_size = pool_size or 3

  instance.pooler = Pooler.new(instance.pool_size)
  instance.pooler:spawn(
    function()
      return instance:spawn()
    end
  )
  return instance
end

function M:spawn()
  return factory.create(self.factory_url)
end

function M:get_available_hit_label()
  local item = self.pooler:pull()

  if not item then
    return self.pooler:push()
  end

  return item
end

---@class HitLabelOptions
---@field start_position vector3?
---@field end_y number?
---@field fly_animation_time number?
---@field scale_animation_time number?

---@param value number|string
---@param options HitLabelOptions?
function M:show(value, options)
  options = options or {}
  options.start_position = options.start_position or go.get_position()
  options.start_position.z = options.start_position.z + 2
  local fly_animation_time = options.fly_animation_time or 0.8

  local hit_label = self:get_available_hit_label()

  if not hit_label then
    return
  end

  msg.post(hit_label, Msg.SHOW_ELEMENT, {
    start_position = options.start_position,
    end_y = options.end_y,
    fly_animation_time = options.fly_animation_time,
    scale_animation_time = options.scale_animation_time,
    value = value,
  })

  timer.delay(fly_animation_time, false, function()
    msg.post(hit_label, Msg.HIDE_ELEMENT)
    self.pooler:push_item(hit_label)
  end)
end

return M
