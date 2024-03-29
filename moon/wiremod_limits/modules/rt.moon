hook.Add "InitPostEntity", "CFC_WiremodLimitations_DisableRT", ->
    return unless WireLib

    hook.Remove "PreRender", "ImprovedRTCamera"
    scripted_ents.GetStored("gmod_wire_rt_camera").t.InitRTTexture = ->
