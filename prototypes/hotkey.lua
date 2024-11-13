local function create_hotkey(name, key_sequence, alternative_key_sequence)
  return {
    type = "custom-input",
    name = NAME .. '-' .. name .. '-control',
    key_sequence = key_sequence,
    alternative_key_sequence = alternative_key_sequence,
    consuming = "game-only"
  }
end

data:extend{create_hotkey("toggle", "CONTROL + K", "")}
