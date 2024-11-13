require("core.constants")

local function create_color_setting(name, default_value, order)
  return {
    name = NAME .. "-" .. name,
    default_value = default_value,
    order = order,
    type = "color-setting",
    setting_type = "runtime-per-user",
    allow_blank = true
  }
end

data:extend{
  create_color_setting("interaction-circle-color", { 1, 1, 1, 0.8 }, "q1"),
  create_color_setting("mining-circle-color", { 239, 33, 36, 199 }, "q2"),
  create_color_setting("pickup-circle-color", { 0, 0.3, 0, 0.2 }, "q3")
}
