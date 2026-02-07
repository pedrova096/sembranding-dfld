local M = {}
M.__index = M

function M.toggle_sprite(enabled, sprite_url)
  go.set(sprite_url, "tint.w", enabled and 1 or 0)
end

function M.toggle_body(enabled, body_url)
  local message = enabled and "enable" or "disable"
  msg.post(body_url, message)
end

function M.toggle_element(enabled, urls)
  M.toggle_body(enabled, urls.body)
  M.toggle_sprite(enabled, urls.sprite)
end

function M.show_element(urls)
  M.toggle_element(true, urls)
end

function M.hide_element(urls)
  M.toggle_element(false, urls)
end

return M
