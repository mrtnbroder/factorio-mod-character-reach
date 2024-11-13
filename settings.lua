require('core.constants')
-- require('core.settings')

-- local function create_color_setting(name, default_value, order)
--   return {
--     name = NAME .. "-" .. name,
--     default_value = default_value,
--     order = order,
--     type = "color-setting",
--     setting_type = "runtime-per-user",
--     allow_blank = true
--   }
-- end

-- for name, setting in ipairs(defines[NAME].settings) do
--   local option = create_color_setting(name, setting.default_value, setting.order)

--   data:extend{option}
-- end

data.extend {{
  name = NAME .. "_interaction-circle-color",
  default_value = {1, 1, 1, 0.8},
  order = "q1",
  type = "color-setting",
  setting_type = "runtime-per-user",
  allow_blank = true
}, {
  name = NAME .. "_mining-circle-color",
  default_value = {239, 33, 36, 199},
  order = "q2",
  type = "color-setting",
  setting_type = "runtime-per-user",
  allow_blank = true
}, {
  name = NAME .. "_pickup-circle-color",
  default_value = {0, 0.3, 0, 0.2},
  order = "q3",
  type = "color-setting",
  setting_type = "runtime-per-user",
  allow_blank = true
}}
