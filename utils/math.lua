local M = {}
M.__index = M

function M.lerp(a, b, t)
  return a + (b - a) * t
end

function M.easing_out_cubic(t)
  return 1 - math.pow(1 - t, 3)
end

return M
