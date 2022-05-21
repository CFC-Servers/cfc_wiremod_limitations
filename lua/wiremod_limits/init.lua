CFCWiremodLimits = {
  Lib = { }
}
include("lib/throttle.lua")
include("lib/e2.lua")
return hook.Add("InitPostEntity", "CFC_WiremodLimits_LoadModules", function()
  include("wiremod_limits/modules/e2.lua")
  include("wiremod_limits/modules/user.lua")
  return nil
end)
