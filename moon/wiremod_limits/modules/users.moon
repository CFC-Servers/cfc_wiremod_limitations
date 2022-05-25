with throttle = Throttler\build!
    .delay = 0.5
    .budget = 5
    .refillRate = 0.5

user = scripted_ents.GetStored( "gmod_wire_user" ).t
user._Throttled_TriggerInput or= user.TriggerInput

user.TriggerInput = Throttler\create user._Throttled_TriggerInput, throttle
