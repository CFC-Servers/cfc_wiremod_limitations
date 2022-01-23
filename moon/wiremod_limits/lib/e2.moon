import wrapEntWithThrottle from CFCWiremodLimits.Lib

CFCWiremodLimits.Lib.E2 = {}
e2 = CFCWiremodLimits.Lib.E2

_groupID = 0
groupID = ->
    _groupID += 1
    _groupID

-- Impose a throttle on a group of signatures
-- All signatures share the same throttle
e2.throttleGroup = (signatures, delay=1, budget=1, refillRate=1, alertFailure=true, shouldSkip=nil, adjustParams=nil) ->
    groupName = "limit_group_#{groupID!}"

    funcs = wire_expression2_funcs
    originals = {s, funcs[s][3] for s in *signatures}

    makeThrottler = (sig) ->
        id = groupName
        success = originals[sig]

        if alertFailure
            failure = =>
                @player\ChatPrint "'#{sig}' was rate-limited! You must wait #{delay} seconds between executions (or wait for your burst budget to refill)"
                @player\ChatPrint "(Burst Budget: #{budget} | Refill Rate: #{refillRate}/second)"

        wrapEntWithThrottle id, delay, budget, refillRate, success, failure, shouldSkip, adjustParams

    funcs[sig][3] = makeThrottler sig for sig in *signatures

-- Throttle an individual signature
e2.throttleFunc = (signature, delay, message) ->
    e2.throttleGroup {signature}, delay, message

-- Throttle a group of signatures independently, but with the same settings
e2.throttleFuncs = (signatures, delay, message) ->
    for signature in *signatures
        throttleFunc signature, delay, message
