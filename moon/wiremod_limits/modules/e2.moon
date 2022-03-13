import E2 from CFCWiremodLimits.Lib

do
    holoScale = {
        "holoScale(nv)"
        "holoBoneScale(nnv)"
        "holoBoneScale(nsv)"
        "holoScaleUnits(nv)"
    }

    with throttle = Throttler\build!
        .delay = 0.15
        .refillRate = 5
        .burstBudget = 750
        .alertFailure = true
        .shouldSkip = => return true if @player\IsAdmin!

        E2.throttleGroup holoScale, throttle

do
    holoClip = {
        "holoClip(nnvvn)"
        "holoClip(nvvn)"
        "holoClip(nnvve)"
        "holoClip(nvve)"
    }

    with throttle = Throttler\build!
        .delay = 0.15
        .burstBudget = 750
        .alertFailure = true
        .shouldSkip = => return true if @player\IsAdmin!

        E2.throttleGroup holoClip, throttle

do
    use = {
        "use(e:)"
    }

    with throttle = Throttler\build!
        .delay = 0.15
        .burstBudget = 50
        .alertFailure = true
        .shouldSkip = => return true if @player\IsAdmin!

        E2.throttleGroup use, throttle
