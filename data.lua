local prefix = "__character_reach_indicator__"
local prefix_graphics = prefix .. "/graphics/"

local name_prefix = "theis_character-reach-indicator"

data.raw.shortcut[name_prefix.."_toggle"] = {
    type = "shortcut",
    name = name_prefix.."_toggle",
    toggleable = true,
    action = "lua",
    localised_name = {name_prefix..".toggle"},
    associated_control_input = name_prefix.."_toggle-control",
    icon = {
        filename = prefix_graphics.."teleport.png",
        size = 64,
    },
}

data:extend({
    {
        type = "sprite",
        name = name_prefix.."_toggle-icon",
        filename = prefix_graphics.."teleport.png",
        position = { 0, 0 },
        size = 64,
        flags = { "icon" },
    },
    
})

local function add_hotkey(name, key_sequence, alternative_key_sequence, order)
    data:extend({
        {
            type = "custom-input",
            name = name,
            key_sequence = key_sequence,
            alternative_key_sequence = alternative_key_sequence,
            consuming = "game-only",
            order = order,
        }
    })
end

add_hotkey(name_prefix.."_toggle-control", "CONTROL + K", "", "a")
