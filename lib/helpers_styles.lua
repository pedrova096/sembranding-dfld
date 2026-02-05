return {
  default = {
    font_height = 12,
    spacing = 2,    -- pixels between letters
    scale = 0.6,    -- scale of character
    waving = false, -- if true - do waving by sinus
    color = "#fdfdfd",
    speed = 0,
    appear = 0,
    shaking = 0, -- shaking power. Set to 0 to disable
    --sound = "letter",
    can_skip = true,
    shake_on_write = 0 -- when letter appear, shake dialogue screen
  },

  yellow = {
    color = "#ffd95a",
    waving = true
  },
  blue = {
    color = "#2357d5",
    waving = true
  },
  red = {
    color = "#e10e3c",
    waving = true
  },
  green = {
    color = "#8ed73d",
    waving = true
  },
}
