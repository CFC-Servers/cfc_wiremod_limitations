import CurTime from _G
import min, floor from math

CFCWiremodLimits.E2 = {}
e2 = CFCWiremodLimits.E2

_groupID = 0
groupID = ->
    _groupID += 1
    _groupID

-- Impose a throttle on a group of signatures
-- All signatures share the same throttle
e2.throttleGroup = (signatures, delay, burstBudget=0, message=nil) ->
    groupName = "limit_group_#{groupID!}"

    funcs = wire_expression2_funcs
    originals = {s, funcs[s][3] for s in *signatures}

    makeThrottler = (sig) -> (args) =>
        og = -> originals[sig](self, args)
        return og! if @player\IsAdmin!

        @player.E2Throttle or= {}
        @player.E2Throttle[groupName] or= {
            budget: burstBudget
            lastUse: 0
        }

        now = CurTime!
        group = @player.E2Throttle[groupName]

        -- Refill budget
        sinceLastUse = now - group.lastUse
        group.budget = min(group.budget + floor(sinceLastUse), burstBudget)

        if group.budget > 0
            group.budget -= 1
            group.lastUse = now
            return og!

        -- Has no budget, back to throttling
        if sinceLastUse < delay
            @player\ChatPrint(message) if message
            return false

        group.lastUse = now
        return og!

    funcs[sig][3] = makeThrottler sig for sig in *signatures

-- Throttle an individual signature
e2.throttleFunc = (signature, delay, message) ->
    e2.throttleGroup {signature}, delay, message

-- Throttle a group of signatures independently, but with the same settings
e2.throttleFuncs = (signatures, delay, message) ->
    for signature in *signatures
        throttleFunc signature, delay, message

