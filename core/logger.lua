Logger = {
  level = 3,
  log_levels = {
    none = 0,
    error = 1,
    warn = 2,
    info = 3,
    debug = 4,
    trace = 5
   }
}

local limit = 3

local function objectToString(value, level)
  if level == nil then level = 0 end
  local message = ""
  if type(value) == "nil" then
    message = message .. " nil"
  elseif type(value) == "boolean" then
    if value then
      message = message .. " true"
    else
      message = message .. " false"
    end
  elseif type(value) == "number" then
    message = message .. " " .. value
  elseif type(value) == "string" then
    message = message .. "\"" .. value .. "\""
  elseif type(value) == "function" then
    message = message .. "\"__function\""
  elseif value.isluaobject then
    if value.valid then
      local lua_type = value.object_name
      if lua_type == "LuaCustomTable" then
        local custom_table = {}
        for _, element in pairs(value) do table.insert(custom_table, element) end
        return objectToString(custom_table, level)
      elseif string.find(lua_type, "Lua") then
        local object_name = "unknown"
        pcall(function()
          object_name = value.name
        end)
        message = message .. string.format("{\"type\":%q,\"name\":%q}", lua_type, object_name or "nil")
      else
        message = message .. string.format("{\"type\":%q,\"name\":%q}", value.type or "nil", value.name or "nil")
      end
    else
      message = message .. "invalid object"
    end
  elseif type(value) == "table" then
    if level <= limit then
      local first = true
      message = message .. "{"
      for k, v in pairs(value) do
        if not first then message = message .. "," end
        message = message .. "\"" .. k .. "\"" .. ":" .. objectToString(v, level + 1);
        first = false
      end
      message = message .. "}"
    else
      message = message .. "\"" .. "__table" .. "\""
    end
  end
  return string.gsub(message, "\n", "")
end

function Logger:error(...)
  if self.level >= self.log_levels.error then
    local arg = { ... }
    self:log("[ERROR]", table.unpack(arg))
  end
end

function Logger:warn(...)
  if self.level >= self.log_levels.warn then
    local arg = { ... }
    self:log("[WARN]", table.unpack(arg))
  end
end

function Logger:info(...)
  if self.level >= self.log_levels.info then
    local arg = { ... }
    self:log("[INFO]", table.unpack(arg))
  end
end

function Logger:debug(...)
  if self.level >= self.log_levels.debug then
    local arg = { ... }
    self:log("[DEBUG]", table.unpack(arg))
  end
end

function Logger:trace(...)
  if self.level >= self.log_levels.trace then
    local arg = { ... }
    self:log("[TRACE]", table.unpack(arg))
  end
end

function Logger:log(tag, message, ...)
  local _arg = { ... }
  local _message = message

  for _, value in ipairs(_arg) do _message = _message .. " " .. objectToString(value) end

  log(string.format("%s: %s", tag, _message))
end

Logger:info("Logger loaded")
