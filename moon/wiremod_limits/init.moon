export CFCWiremodLimits = {}

include "lib/e2.lua"

hook.Add "InitPostEntity", "CFC_WiremodLimits_LoadModules", ->
    include "modules/e2.lua"
