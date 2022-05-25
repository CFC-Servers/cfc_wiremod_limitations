do
  local throttle = Throttler:build()
  throttle.delay = 0.5
  throttle.budget = 5
  throttle.refillRate = 0.5
end
local user = scripted_ents.GetStored("gmod_wire_user").t
user._Throttled_TriggerInput = user._Throttled_TriggerInput or user.TriggerInput
user.TriggerInput = Throttler:create(user._Throttled_TriggerInput, throttle)
