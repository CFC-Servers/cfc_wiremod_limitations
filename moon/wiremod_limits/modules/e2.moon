import E2 from CFCWiremodLimits

do
    delay = 0.15
    burstBudget = 45

    holoScale = {
        "holoScale(nv)"
        "holoBoneScale(nnv)"
        "holoBoneScale(nsv)"
        "holoScaleUnits(nv)"
    }

    E2.throttleGroup holoScale, delay, burstBudget

do
    delay = 0.15
    burstBudget = 45

    holoClip = {
        "holoClip(nnvvn)"
        "holoClip(nvvn)"
        "holoClip(nnvve)"
        "holoClip(nvve)"
    }

    E2.throttleGroup holoClip, delay, burstBudget
