import CurTime, IsValid from _G

CFCWiremodLimits.Lib.E2 = {
    alertDelay: 3
}
e2 = CFCWiremodLimits.Lib.E2

-- Impose a throttle on a group of signatures
-- All signatures share the same throttle
e2.throttleGroup = (signatures, throttleStruct) ->
    groupName = "limit_group_#{throttleStruct.id}"
    {:alertFailure, :delay, :budget, :refillRate} = throttleStruct

    funcs = wire_expression2_funcs
    originals = {s, funcs[s][3] for s in *signatures}

    makeThrottler = (sig) ->
        id = groupName

        failure = =>
            ply = @player
            return unless IsValid ply

            throttleAlerts = ply.E2ThrottleAlerts

            -- Failsafe, should be set on PlayerInitialSpawn
            if not throttleAlerts
                ply.E2ThrottleAlerts = {}

            now = CurTime!
            lastAlert = throttleAlerts[id] or 0
            return if lastAlert > now - e2.alertDelay

            ply\ChatPrint "'#{sig}' was rate-limited! You must wait #{delay} seconds between executions (or wait for your budget to refill)"
            ply\ChatPrint "(Budget: #{budget} | Refill Rate: #{refillRate}/second)"
            throttleAlerts[id] = now

        throttleStruct.failure = failure if alertFailure

        Throttler\create originals[sig], throttleStruct

    funcs[sig][3] = makeThrottler sig for sig in *signatures

-- FIXME: these need to use structs
-- Throttle an individual signature
e2.throttleFunc = (signature, delay, message) ->
    e2.throttleGroup {signature}, delay, message

-- Throttle a group of signatures independently, but with the same settings
e2.throttleFuncs = (signatures, delay, message) ->
    for signature in *signatures
        e2.throttleFunc signature, delay, message

-- Wraps a set of functions with the same wrapper.
-- The wrapper receives the original function as the first argument
-- followed by the arguments passed to the original function
e2.wrapGroup = (signatures, wrapper) ->
    funcs = wire_expression2_funcs
    originals = {}

    for signature in *signatures
        original = funcs[signature][3]
        originals[signature] = original

        funcs[signature][3] = (...) ->
            wrapper original, ...

e2.wrapFunc = (signature, wrapper) ->
    e2.wrapGroup {signature}, wrapper

hook.Add "PlayerInitialSpawn", "WiremodLimits_E2ThrottleSetup", (ply) ->
    ply.E2ThrottleAlerts = {}
