import E2 from CFCWiremodLimits

do
    delay = 0.15
    burstBudget = 500

    holoScale = {
        "holoScale(nv)"
        "holoBoneScale(nnv)"
        "holoBoneScale(nsv)"
        "holoScaleUnits(nv)"
    }

    E2.throttleGroup holoScale, delay, burstBudget

do
    delay = 0.15
    burstBudget = 500

    holoClip = {
        "holoClip(nnvvn)"
        "holoClip(nvvn)"
        "holoClip(nnvve)"
        "holoClip(nvve)"
    }

    E2.throttleGroup holoClip, delay, burstBudget

do
    delay = 0.15
    burstBudget = 50

    use = {
        "use(e:)"
    }

    E2.throttleGroup use, delay, burstBudget
