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
        .refillRate = 35
        .budget = 750
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
        .refillRate = 15
        .budget = 750
        .alertFailure = true
        .shouldSkip = => return true if @player\IsAdmin!

        E2.throttleGroup holoClip, throttle

do
    use = {
        "use(e:)"
    }

    with throttle = Throttler\build!
        .delay = 0.15
        .budget = 50
        .alertFailure = true
        .shouldSkip = => return true if @player\IsAdmin!

        E2.throttleGroup use, throttle

do
    toEntity = {
        "applyAngForce(e:a)"
        "applyForce(e:v)"
        "applyOffsetForce(e:vv)"
    }

    subjectIsRagdoll = (args) ->
        ent = args[1]
        return ent\IsRagdoll!

    subjectWrapper = (original, self, args, ...) ->
        @throw "[CFC] applyForce functions are disabled on ragdolls" if subjectIsRagdoll args
        original self, args, ...

    E2.wrapGroup toEntity, subjectWrapper

do
    toBone = {
        "applyAngForce(b:a)"
        "applyForce(b:v)"
        "applyOffsetForce(b:vv)"
    }

    subjectWrapper = (_, self) ->
        @throw "[CFC] applyForce functions are disabled on bones"

    E2.wrapGroup toBone, subjectWrapper
