export CFCWiremodLimits = {}

include "lib/e2.lua"

hook.Add "InitPostEntity", "CFC_WiremodLimits_LoadModules", ->
    include "wiremod_limits/modules/e2.lua"
