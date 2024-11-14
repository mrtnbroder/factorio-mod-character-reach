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

  for _, v in ipairs(_arg) do _message = _message .. " " .. tostring(v) end

  log(string.format("%s: %s", tag, _message))
end

Logger:info("Logger loaded")
