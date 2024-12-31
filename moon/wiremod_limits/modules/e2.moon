import E2 from CFCWiremodLimits.Lib

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
        return ent and ent\IsRagdoll!

    subjectWrapper = (original, runtime, args, ...) ->
        shouldHalt = subjectIsRagdoll(args) and not runtime.player\IsAdmin!
        if shouldHalt
            runtime\forceThrow "[CFC] applyForce functions are disabled on ragdolls"

        original runtime, args, ...

    E2.wrapGroup toEntity, subjectWrapper

do
    toBone = {
        "applyAngForce(b:a)"
        "applyForce(b:v)"
        "applyOffsetForce(b:vv)"
    }

    disabler = (original, runtime, args, ...) ->
        unless runtime.player\IsAdmin!
            runtime\forceThrow "[CFC] applyForce functions are disabled on bones"

        original runtime, args, ...

    E2.wrapGroup toBone, disabler
