import E2 from CFCWiremodLimits

do
    holoScale = {
        "holoScale(nv)"
        "holoBoneScale(nnv)"
        "holoBoneScale(nsv)"
        "holoScaleUnits(nv)"
    }

    E2.throttleGroup holoScale, 0.15

do
    holoClip = {
        "holoClip(nnvvn)"
        "holoClip(nvvn)"
        "holoClip(nnvve)"
        "holoClip(nvve)"
    }

    E2.throttleGroup holoClip, 0.15
