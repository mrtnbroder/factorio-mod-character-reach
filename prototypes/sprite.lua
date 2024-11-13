local function create_sprite(name, filename)
  return {
    type = "sprite",
    name = NAME .. "-" .. name,
    filename = GRAPHICS_DIR .. filename .. ".png",
    position = {0, 0},
    size = 64,
    flags = {"icon"}
  }
end

data:extend{create_sprite("toggle-icon", "teleport")}
