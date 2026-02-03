local M = {}
M.__index = M

function M.lerp(a, b, t)
  return a + (b - a) * t
end

function M.easing_out_cubic(t)
  return 1 - math.pow(1 - t, 3)
end

function M.random_pick(table)
  return table[math.random(1, #table)]
end

function M.sign(value, default)
  default = default or 1
  return value > 0 and 1 or value < 0 and -1 or default
end

return M
