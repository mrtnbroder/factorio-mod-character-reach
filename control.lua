require('core.constants')

local name_interaction = NAME .. "-interaction"
local name_mining = NAME .. "-mining"
local name_pickup = NAME .. "-pickup"

---Draws a circle around the player
---@param player LuaPlayer
---@param radius double
---@param color Color
---@param is_filled boolean
---@return integer rendering_id
local function draw_circle(player, radius, color, is_filled)
  if not player.character or not player.surface then
    return 0
  end
  return rendering.draw_circle {
    color = color,
    radius = radius,
    -- width = 2,
    filled = is_filled,
    target = player.character,
    surface = player.surface,
    players = {player.index},
    draw_on_ground = true
  }
end

local function destroy_circles(player_index)
  if storage.players_refs[player_index] then
    rendering.destroy(storage.players_refs[player_index].large)
    rendering.destroy(storage.players_refs[player_index].medium)
    rendering.destroy(storage.players_refs[player_index].small)
    storage.players_refs[player_index] = nil
  end
end

local function create_circles(player_index)
  local player = game.get_player(player_index)
  if not player then
    return
  end

  local reach_distance = player.reach_distance
  local resource_reach_distance = player.resource_reach_distance
  local item_pickup_distance = player.item_pickup_distance
  storage.players_color_refs = storage.players_color_refs or {}
  if not storage.players_color_refs[player_index] then
    local setting = settings.get_player_settings(player_index)
    storage.players_color_refs[player_index] = {setting[name_interaction].value, setting[name_mining].value,
      setting[name_pickup].value}
  end
  storage.players_refs[player_index] = {
    player = player,
    reach_distance = reach_distance,
    resource_reach_distance = resource_reach_distance,
    item_pickup_distance = item_pickup_distance,
    large = draw_circle(player, reach_distance, storage.players_color_refs[player_index][1], false),
    medium = draw_circle(player, resource_reach_distance, storage.players_color_refs[player_index][2], false),
    small = draw_circle(player, item_pickup_distance, storage.players_color_refs[player_index][3], true)
  }
end

---Toggles circles for the player clicking the tool
---@param event EventData.on_lua_shortcut | EventData.CustomInputEvent
local function toggle_circles(event)
  log("toggle_circles")
  log(event.input_name or event.prototype_name)
  -- local name = NAME .. "-toggle"
  -- local event_name = event.input_name or event.prototype_name
  -- if event_name ~= NAME .. "-toggle-control" and event_name ~= name then
  --   return
  -- end
  -- local player = game.get_player(event.player_index)
  -- if not player or player.controller_type ~= defines.controllers.character then
  --   return
  -- end

  -- if storage.players_refs[event.player_index] then
  --   destroy_circles(event.player_index)
  --   player.set_shortcut_toggled(name, false)
  -- else
  --   create_circles(event.player_index)
  --   player.set_shortcut_toggled(name, true)
  -- end
end

---@param player_index integer
local function recreate_circles(player_index)
  if storage.players_refs[player_index] then
    destroy_circles(player_index)
    create_circles(player_index)
  end
end

---@param event EventData.on_player_changed_surface
local function move_circles(event)
  recreate_circles(event.player_index)
end

---@param event EventData.on_player_changed_force
local function change_circle_range(event)
  if not storage.players_refs[event.player_index] then
    return
  end
  local item = storage.players_refs[event.player_index]
  local player = item.player
  if player.reach_distance ~= item.reach_distance or player.resource_reach_distance ~= item.resource_reach_distance or
    player.item_pickup_distance ~= item.item_pickup_distance then
    recreate_circles(event.player_index)
  end
end

---@param event EventData.on_force_reset | EventData.on_forces_merged
local function force_modified(event)
  local force = event.force or event.destination
  for _, player in pairs(force.connected_players) do
    change_circle_range({
      force = event.force,
      name = defines.events.on_player_changed_force,
      player_index = player.index,
      tick = event.tick
    })
  end
end

---@param event EventData.on_player_joined_game | EventData.on_player_toggled_map_editor
local function on_player_joined_game(event)
  local player = game.get_player(event.player_index)
  if not player then
    return
  end
  if player.controller_type == defines.controllers.character and storage.players_refs[event.player_index] then
    create_circles(event.player_index)
    player.set_shortcut_toggled(NAME .. "-toggle", true)
  end
end

--[[ ---@param event EventData.on_player_left_game
local function on_player_left_game(event)
end ]]

---@param event EventData.on_player_removed
local function on_player_removed(event)
  if storage.players_refs[event.player_index] then
    destroy_circles(event.player_index)
  end
end

---Handling of changing the color of the player's circles
---@param event EventData.on_runtime_mod_setting_changed
local function on_setting_change(event)
  local player_index = event.player_index
  if not player_index then
    return
  end
  local player = game.get_player(player_index)
  if not player or event.setting_type ~= "runtime-per-user" then
    return
  end

  local settings_lookup = {
    [name_interaction] = 1,
    [name_mining] = 2,
    [name_pickup] = 3
  }
  local setting_index = settings_lookup[event.setting]
  if not setting_index then
    return
  end

  storage.players_color_refs = storage.players_color_refs or {}
  if not storage.players_color_refs[player_index] then
    local setting = settings.get_player_settings(player_index)
    storage.players_color_refs[player_index] = {setting[name_interaction].value, setting[name_mining].value,
      setting[name_pickup].value}
  else
    storage.players_color_refs[player_index][setting_index] =
      settings.get_player_settings(player_index)[event.setting].value
  end
  recreate_circles(player_index)
end

local next = next

---@param event NthTickEventData
local function on_nth_tick_10(event)
  local player_refs = storage.players_refs
  local current_player_index = storage.current_player_index
  if not player_refs[current_player_index] then
    current_player_index = nil
  end
  local refs
  current_player_index, refs = next(player_refs, current_player_index)
  storage.current_player_index = current_player_index
  if refs then
    change_circle_range({
      force = refs.player.force,
      name = defines.events.on_player_changed_force,
      player_index = current_player_index,
      tick = event.tick
    })
  end
end

script.on_event(defines.events.on_lua_shortcut, toggle_circles)
script.on_event(NAME .. "-toggle", toggle_circles)
script.on_event(defines.events.on_player_changed_surface, move_circles)

script.on_event(defines.events.on_player_changed_force, change_circle_range)
script.on_event(defines.events.on_force_reset, force_modified)
script.on_event(defines.events.on_forces_merged, force_modified)

-- script.on_event(defines.events.on_player_created,)
script.on_event(defines.events.on_player_joined_game, on_player_joined_game)
-- script.on_event(defines.events.on_player_left_game, on_player_left_game)
script.on_event(defines.events.on_player_removed, on_player_removed)

script.on_event(defines.events.on_runtime_mod_setting_changed, on_setting_change)

script.on_event(defines.events.on_player_toggled_map_editor, on_player_joined_game)

script.on_nth_tick(10, on_nth_tick_10)

script.on_init(function()
  storage.players_refs = storage.players_refs or {}
end)
