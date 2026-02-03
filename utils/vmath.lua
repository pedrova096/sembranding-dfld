local M = {}
M.__index = M

---Return a random vector3 with the given min and max values
---@param min number
---@param max number
---@return vector3
function M.random_vector2D(min, max)
  local x = math.random(min, max)
  local y = math.random(min, max)

  return vmath.vector3(x, y, 0)
end

---Returns a random direction vector3
---@return vector3
function M.random_direction()
  local angle = math.random(0, 360)
  return vmath.vector3(math.cos(angle), math.sin(angle), 0)
end

---Returns a vector3 with the z component set to number
---@param source vector3
---@param number number
---@return vector3
function M.z_extends(source, number)
  return vmath.vector3(source.x, source.y, number)
end

---Returns a vector3 with the z component set to 0
---@param vector vector3
---@return vector3
function M.z_zero(vector)
  return M.z_extends(vector, 0)
end

---Clamps the length of a vector to a maximum value
---@param source vector3
---@param max_length number
---@return vector3
function M.clamp_length(source, max_length)
  local length = vmath.length(source)
  if length > max_length then
    return vmath.normalize(source) * max_length
  end

  return source
end

---Checks if a vector is zero
---@param source vector3
---@param epsilon? number
---@return boolean
function M.is_near_zero(source, epsilon)
  epsilon = epsilon or 0.01
  return source.x < epsilon and source.y < epsilon and source.z < epsilon
end

---Checks if a vector is near a value
---@param source vector3
---@param target vector3
---@param epsilon? number
---@return boolean
function M.is_near_close_to(source, target, epsilon)
  epsilon = epsilon or 1.0
  local delta = target - source
  return vmath.length(delta) < epsilon
end

return M
