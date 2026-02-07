local M = {}
M.__index = M

local function get_viewport_size()
  local DISPLAY_WIDTH = sys.get_config_int("display.width")
  local DISPLAY_HEIGHT = sys.get_config_int("display.height")

  return {
    width = DISPLAY_WIDTH,
    height = DISPLAY_HEIGHT,
  }
end

local VIEWPORT_SIZE = get_viewport_size()

function M.get_display_size()
  local display_width = sys.get_config_int("display.width")
  local display_height = sys.get_config_int("display.height")

  return display_width, display_height
end

function M.get_zoom_level()
  local display_width, display_height = M.get_display_size()
  local windows_width, windows_height = window.get_size()

  local zoom_level = math.min(windows_width / display_width, windows_height / display_height)

  return zoom_level
end

return M
