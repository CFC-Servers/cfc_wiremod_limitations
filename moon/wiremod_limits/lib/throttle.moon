import isentity, istable CurTime from _G
import min from math

noop = ->
getself = (thing) -> thing
lib = CFCWiremodLimits.Lib

-- # All functions receive the full set of parameters that its return function receives #
--
-- Params:
--   id
--     a string identifier for this throttle
--
--   ent
--     Which entity to track the throttles on
--       - Accepts nil if you expect the first param of each call to be the entity to track
--       - Accepts a function if you need to figure it out yourself each call (gets all params of the wrapped func)
--
--   delay
--     How long between executions
--
--   budget
--     How many times it can be called before being delayed
--
--   refillRate
--     How much of budget to refill per second
--
--   success
--     Run when not throttled
--
--   failure
--     Run if execution is prevented
--
--   shouldSkip
--     Decides if throttling logic should be skipped (return true to skip)
--
--   adjustParams
--     Return a table with any of the following keys: ["delay", "budget", "refillRate"] to override the initial settings for this execution

lib.wrapWithThrottle = (
    id,
    ent=getself,
    delay=1,
    budget=1,
    refillRate=1,
    success=noop,
    failure=noop,
    shouldSkip=noop,
    adjustParams=nil) ->

    (...) ->
        args = {...}
        succeed = -> success unpack args
        fail = -> failure unpack args

        return succeed! if shouldSkip(...) == true

        -- Perform adjustments
        if adjustParams
            adjustments = adjustParams ...

            delay = adjustments.delay or delay
            budget = adjustments.budget or budget
            refillRate = adjustments.refillRate or refillRate

        -- If ent is an entity, use it, otherwise call it as a function with the given params
        ent = isentity(ent) and ent or ent ...

        ent._Throttles or= {}
        ent._Throttles[id] or= {
            budget: budget
            lastUse: 0
        }

        now = CurTime!
        throttle = ent._Throttles[id]

        -- Refill the budget
        sinceLastUse = now - group.lastUse
        refillAmount = sinceLastUse * refillRate
        throttle.budget = min(throttle.budget + refillAmount, budget)

        -- Has budget, can use
        if throttle.budget > 0
            throttle.budget -= 1
            throttle.lastUse = now
            return succeed!

        -- Blocked by delay
        if sinceLastUse < delay
            fail!
            return false

        -- No budget, but has waited long enough since the last use
        throttle.lastUse = now
        return succeed!

-- When wrapping a method on an entity, store the budget on the ent that is received in the call
lib.wrapEntWithThrottle = (id, delay, budget, refillRate, success, failure=noop) ->
    lib.wrapWithThrottle id, nil, delay, budget, refillRate, success, failure

