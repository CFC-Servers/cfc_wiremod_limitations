import rawget, rawset, CurTime, IsValid from _G

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

        failure = alertFailure and =>
            ply = rawget self, "player"
            return unless IsValid ply

            throttleAlerts = ply.E2ThrottleAlerts

            -- Failsafe, should be set on PlayerInitialSpawn
            if not throttleAlerts
                ply.E2ThrottleAlerts = {}

            now = CurTime!
            lastAlert = rawget(throttleAlerts, id) or 0
            return if lastAlert > now - rawget(e2, "alertDelay")

            ply\ChatPrint "'#{sig}' was rate-limited! You must wait #{delay} seconds between executions (or wait for your budget to refill)"
            ply\ChatPrint "(Budget: #{budget} | Refill Rate: #{refillRate}/second)"
            rawset throttleAlerts, id, now

        throttleStruct.failure = failure if failure

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

hook.Add "PlayerInitialSpawn", "WiremodLimits_E2ThrottleSetup", (ply) ->
    ply.E2ThrottleAlerts = {}
