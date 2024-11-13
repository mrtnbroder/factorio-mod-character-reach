require('core.constants')
require('core.settings')

local function create_color_setting(name, default_value, order)
  return {
    name = NAME .. name,
    default_value = default_value,
    order = order,
    type = "color-setting",
    setting_type = "runtime-per-user",
    allow_blank = true
  }
end

for name, setting in ipairs(defines[NAME].settings) do
  local option = create_color_setting(name, setting.default_value, setting.order)

  data:extend{option}
end
