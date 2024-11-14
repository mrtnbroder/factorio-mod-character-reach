local EventController = {}

function EventController.setup()
  EventController.pcall_event(defines.events.on_player_created, EventController.on_player_created)
  EventController.pcall_event(defines.events.on_player_joined_game, EventController.on_player_joined_game)
  EventController.pcall_event(defines.events.on_lua_shortcut, EventController.on_lua_shortcut)
end

function EventController.pcall_event(event_type, callback)
  local ok, err = pcall(function()
    script.on_event(event_type, callback)
  end)
  if not (ok) then
    Logger:warn(event_type .. " is not valid!")
    Logger:error(err)
  end
end

function EventController.on_player_created(event)
  Logger:info("Player created", event)
end

function EventController.on_player_joined_game(event)
  Logger:info("Player joined game", event)
end

function EventController.on_lua_shortcut(event)
  Logger:info("Lua shortcut", event)
end

return EventController
