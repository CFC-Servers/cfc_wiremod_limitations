import CurTime from _G

CFCWiremodLimits.E2 = {}
e2 = CFCWiremodLimits.E2

_groupID = 0
groupID = ->
    _groupID += 1
    _groupID

-- Impose a throttle on a group of signatures
-- All signatures share the same throttle
e2.throttleGroup = (signatures, delay, message) ->
    group = "limit_group_#{groupID!}"

    funcs = wire_expression2_funcs
    originals = {s, funcs[s][3] for s in *signatures}

    makeThrottler = (sig) -> (args) =>
        @player.E2Throttle or= {}
        @player.E2Throttle[group] or= 0

        now = CurTime!

        if now - @player.E2Throttle[group] < delay
            @player\ChatPrint(message) if message
            return false

        @player.E2Throttle[group] = now
        return originals[sig](self, args)

    funcs[sig][3] = makeThrottler sig for sig in *signatures

-- Throttle an individual signature
e2.throttleFunc = (signature, delay, message) ->
    e2.throttleGroup {signature}, delay, message

-- Throttle a group of signatures independently, but with the same settings
e2.throttleFuncs = (signatures, delay, message) ->
    for signature in *signatures
        throttleFunc signature, delay, message

