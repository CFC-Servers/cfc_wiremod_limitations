local E2
E2 = CFCWiremodLimits.Lib.E2
do
  local use = {
    "use(e:)"
  }
  do
    local throttle = Throttler:build()
    throttle.delay = 0.15
    throttle.budget = 50
    throttle.alertFailure = true
    throttle.shouldSkip = function(self)
      if self.player:IsAdmin() then
        return true
      end
    end
    E2.throttleGroup(use, throttle)
  end
end
do
  local toEntity = {
    "applyAngForce(e:a)",
    "applyForce(e:v)",
    "applyOffsetForce(e:vv)"
  }
  local subjectIsRagdoll
  subjectIsRagdoll = function(args)
    local ent = args[1]
    return ent and ent:IsRagdoll()
  end
  local subjectWrapper
  subjectWrapper = function(original, runtime, args, ...)
    local shouldHalt = subjectIsRagdoll(args) and not runtime.player:IsAdmin()
    if shouldHalt then
      runtime:forceThrow("[CFC] applyForce functions are disabled on ragdolls")
    end
    return original(runtime, args, ...)
  end
  E2.wrapGroup(toEntity, subjectWrapper)
end
do
  local toBone = {
    "applyAngForce(b:a)",
    "applyForce(b:v)",
    "applyOffsetForce(b:vv)"
  }
  local disabler
  disabler = function(original, runtime, args, ...)
    if not (runtime.player:IsAdmin()) then
      runtime:forceThrow("[CFC] applyForce functions are disabled on bones")
    end
    return original(runtime, args, ...)
  end
  return E2.wrapGroup(toBone, disabler)
end
