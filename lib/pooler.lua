local Table = require("utils.table")

local M = {}
M.__index = M

---@param pool_size number
---@return table
function M.new(pool_size)
  local instance = setmetatable({}, M)

  instance.pool_size = pool_size
  instance.pool_queue = {}
  instance.active_pool = {}
  return instance
end

function M:spawn(spawner)
  for i = 1, self.pool_size do
    local item = spawner(i)
    table.insert(self.pool_queue, item)
  end
end

function M:pull()
  local item = table.remove(self.pool_queue, 1)

  if not item then
    return nil
  end

  table.insert(self.active_pool, item)
  return item, #self.active_pool
end

function M:push()
  local item = table.remove(self.active_pool, 1)

  if not item then
    return nil
  end

  table.insert(self.pool_queue, item)
  return item, #self.active_pool
end

function M:push_item(item)
  local _, removed = Table.remove_value(self.active_pool, item)

  if not removed then
    return
  end

  table.insert(self.pool_queue, item)
end

function M:push_index(index)
  local item = table.remove(self.active_pool, index)
  table.insert(self.pool_queue, item)
  return item
end

function M:pull_item(item)
  local _, removed = Table.remove_value(self.pool_queue, item)

  if not removed then
    return
  end

  table.insert(self.active_pool, item)
end

function M:available_size()
  return #self.pool_queue
end

function M:active_size()
  return #self.active_pool
end

function M:reset()
  for _, item in ipairs(self.active_pool) do
    table.insert(self.pool_queue, item)
  end

  self.active_pool = {}
end

function M:find_index(callback)
  for i, item in ipairs(self.active_pool) do
    if callback(item) then
      return i
    end
  end
end

return M
