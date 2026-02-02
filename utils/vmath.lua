local M = {}
M.__index = M

---Return a random vector3 with the given min and max values
---@param min number
---@param max number
---@return vector3
function M.random_vector3(min, max)
  local x = math.random(min, max)
  local y = math.random(min, max)

  return vmath.vector3(x, y, 0)
end

---Returns a vector3 with the z component set to number
---@param vector vector3
---@param number number
---@return vector3
function M.z_extends(vector, number)
  return vmath.vector3(vector.x, vector.y, number)
end

---Returns a vector3 with the z component set to 0
---@param vector vector3
---@return vector3
function M.z_zero(vector)
  return M.z_extends(vector, 0)
end

return M
