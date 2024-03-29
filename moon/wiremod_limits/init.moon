export CFCWiremodLimits = {
    Lib: {}
}

include "lib/throttle.lua"
include "lib/e2.lua"
include "lib/rt.lua"

hook.Add "InitPostEntity", "CFC_WiremodLimits_LoadModules", ->
    include "wiremod_limits/modules/e2.lua"
    return nil
