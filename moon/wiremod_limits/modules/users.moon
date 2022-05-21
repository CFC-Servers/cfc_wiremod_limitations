with throttle = Throtter\build!
    .delay = 0.5
    .budget = 5
    .refillRate = 0.5

user = scripted_ents.GetTable "gmod_wire_user"
user._Throttled_TriggerInput or= user.TriggerInput

user.TriggerInput = Throttler.create user._Throttled_TriggerInput, throttle
