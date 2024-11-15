local function create_shortcut(name, icon, icon_small)
  return {
    type = "shortcut",
    name = NAME .. "-" .. name,
    toggleable = true,
    action = "lua",
    localised_name = {NAME .. "." .. name},
    associated_control_input = NAME .. "-" .. name .. "-control",
    icon = GRAPHICS_DIR .. icon .. ".png",
    icon_size = 64,
    small_icon = GRAPHICS_DIR .. icon_small .. ".png",
    small_icon_size = 32
  }
end

data:extend{create_shortcut("toggle", "teleport", "teleport")}
