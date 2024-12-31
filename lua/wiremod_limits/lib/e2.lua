local CurTime, IsValid
do
  local _obj_0 = _G
  CurTime, IsValid = _obj_0.CurTime, _obj_0.IsValid
end
CFCWiremodLimits.Lib.E2 = {
  alertDelay = 3
}
local e2 = CFCWiremodLimits.Lib.E2
e2.throttleGroup = function(signatures, throttleStruct)
  local groupName = "limit_group_" .. tostring(throttleStruct.id)
  local alertFailure, delay, budget, refillRate
  alertFailure, delay, budget, refillRate = throttleStruct.alertFailure, throttleStruct.delay, throttleStruct.budget, throttleStruct.refillRate
  local funcs = wire_expression2_funcs
  local originals
  do
    local _tbl_0 = { }
    for _index_0 = 1, #signatures do
      local s = signatures[_index_0]
      _tbl_0[s] = funcs[s][3]
    end
    originals = _tbl_0
  end
  local makeThrottler
  makeThrottler = function(sig)
    local id = groupName
    local failure
    failure = function(self)
      local ply = self.player
      if not (IsValid(ply)) then
        return 
      end
      local throttleAlerts = ply.E2ThrottleAlerts
      if not throttleAlerts then
        ply.E2ThrottleAlerts = { }
      end
      local now = CurTime()
      local lastAlert = throttleAlerts[id] or 0
      if lastAlert > now - e2.alertDelay then
        return 
      end
      ply:ChatPrint("'" .. tostring(sig) .. "' was rate-limited! You must wait " .. tostring(delay) .. " seconds between executions (or wait for your budget to refill)")
      ply:ChatPrint("(Budget: " .. tostring(budget) .. " | Refill Rate: " .. tostring(refillRate) .. "/second)")
      throttleAlerts[id] = now
    end
    if alertFailure then
      throttleStruct.failure = failure
    end
    return Throttler:create(originals[sig], throttleStruct)
  end
  for _index_0 = 1, #signatures do
    local sig = signatures[_index_0]
    funcs[sig][3] = makeThrottler(sig)
  end
end
e2.throttleFunc = function(signature, delay, message)
  return e2.throttleGroup({
    signature
  }, delay, message)
end
e2.throttleFuncs = function(signatures, delay, message)
  for _index_0 = 1, #signatures do
    local signature = signatures[_index_0]
    e2.throttleFunc(signature, delay, message)
  end
end
e2.wrapGroup = function(signatures, wrapper)
  local funcs = wire_expression2_funcs
  local originals = { }
  for _index_0 = 1, #signatures do
    local signature = signatures[_index_0]
    local original = funcs[signature][3]
    originals[signature] = original
    funcs[signature][3] = function(...)
      return wrapper(original, ...)
    end
  end
end
e2.wrapFunc = function(signature, wrapper)
  return e2.wrapGroup({
    signature
  }, wrapper)
end
return hook.Add("PlayerInitialSpawn", "WiremodLimits_E2ThrottleSetup", function(ply)
  ply.E2ThrottleAlerts = { }
end)
