local E2
E2 = CFCWiremodLimits.Lib.E2
do
  local holoScale = {
    "holoScale(nv)",
    "holoBoneScale(nnv)",
    "holoBoneScale(nsv)",
    "holoScaleUnits(nv)"
  }
  do
    local throttle = Throttler:build()
    throttle.delay = 0.15
    throttle.refillRate = 5
    throttle.budget = 750
    throttle.alertFailure = true
    throttle.shouldSkip = function(self)
      if self.player:IsAdmin() then
        return true
      end
    end
    E2.throttleGroup(holoScale, throttle)
  end
end
do
  local holoClip = {
    "holoClip(nnvvn)",
    "holoClip(nvvn)",
    "holoClip(nnvve)",
    "holoClip(nvve)"
  }
  do
    local throttle = Throttler:build()
    throttle.delay = 0.15
    throttle.budget = 750
    throttle.alertFailure = true
    throttle.shouldSkip = function(self)
      if self.player:IsAdmin() then
        return true
      end
    end
    E2.throttleGroup(holoClip, throttle)
  end
end
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
    return throttle
  end
end
