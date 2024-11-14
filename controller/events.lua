local EventController = {}

function EventController.setup()
  script.on_init(EventController.on_init)

  EventController.pcall_event(defines.events.on_player_joined_game, EventController.on_player_joined_game)
  EventController.pcall_event(defines.events.on_player_left_game, EventController.on_player_left_game)

  -- EventController.pcall_event(defines.events.on_player_changed_surface, EventController.on_player_changed_surface)
  -- EventController.pcall_event(defines.events.on_player_changed_force, EventController.on_player_changed_force)
  -- EventController.pcall_event(defines.events.on_player_created, EventController.on_player_created)
  EventController.pcall_event(NAME .. "-toggle-control", EventController.on_lua_shortcut)
  EventController.pcall_event(defines.events.on_lua_shortcut, EventController.on_lua_shortcut)

  -- EventController.pcall_event(defines.events.on_force_reset, EventController.on_force_reset)
  -- EventController.pcall_event(defines.events.on_forces_merged, EventController.on_forces_merged)

  EventController.pcall_event(
    defines.events.on_runtime_mod_setting_changed, EventController.on_runtime_mod_setting_changed
  )

  EventController.pcall_event(defines.events.on_player_toggled_map_editor, EventController.on_player_toggled_map_editor)


  EventController.pcall_nth_tick(10, EventController.on_nth_tick_10)

end

function EventController.pcall_event(event_type, callback)
  local ok, err = pcall(
    function()
      script.on_event(event_type, callback)
    end
  )
  if not (ok) then
    Logger:warn(event_type .. " is not valid.")
    Logger:error(err)
  end
end

function EventController.pcall_nth_tick(tick, callback)
  local ok, err = pcall(
    function()
      script.on_nth_tick(tick, callback)
    end
  )
  if not (ok) then
    Logger:warn("Defined pcall_nth_tick is not valid.")
    Logger:error(err)
  end
end

--------------------------------------------------------------------------------
---@param player LuaPlayer
---@return boolean
local function is_player(player)
  return player and player.controller_type == defines.controllers.character
end

--------------------------------------------------------------------------------
---
---
local function toggle_circles(event)
  local toggle_event = NAME .. "-toggle"
  local player = game.get_player(event.player_index)
  local event_name = event.input_name or event.prototype_name

  if event_name ~= toggle_event then return end

  if is_player(player) then
    if storage.players_refs[event.player_index] then
      -- destroy_circles(event.player_index)
      player.set_shortcut_toggled(toggle_event, false)
    else
      -- create_circles(event.player_index)
      player.set_shortcut_toggled(toggle_event, true)
    end
  end
end

function EventController.on_init(event)
  Logger:info("EventController.on_init", event)

  storage.players_refs = storage.players_refs or {}
end

-- function EventController.on_player_created(event)
--   Logger:info("EventController.on_player_created", event)
-- end

---@param event EventData.on_player_joined_game
function EventController.on_player_joined_game(event)
  Logger:info("EventController.on_player_joined_game", event)
end

---@param event EventData.on_player_left_game
function EventController.on_player_left_game(event)
  Logger:info("EventController.on_player_left_game", event)
end

---@param event EventData.on_lua_shortcut
function EventController.on_lua_shortcut(event)
  Logger:info("EventController.on_lua_shortcut", event)
  toggle_circles(event)
end

---@param event EventData.on_runtime_mod_setting_changed
function EventController.on_runtime_mod_setting_changed(event)
  Logger:info("EventController.on_runtime_mod_setting_changed", event)
end

---@param event EventData.on_player_toggled_map_editor
function EventController.on_player_toggled_map_editor(event)
  Logger:info("EventController.on_player_toggled_map_editor", event)
end

---@param event NthTickEventData
function EventController.on_nth_tick_10(event)
  Logger:info("EventController.on_nth_tick_10", event)
end

return EventController
