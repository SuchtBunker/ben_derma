-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.NumberselectionFrame(settings)
	local settings = settings or {}
    settings["text"] = settings["text"] or "Wie viel?"
    settings["min"] = settings["min"] or 1
    settings["max"] = settings["max"] or 100
    settings["decimals"] = settings["decimals"] or 0
    settings["placeholderMinMax"] = settings["placeholderMinMax"] or (settings["min"].." - "..settings["max"])
    settings["w"] = settings["w"] or 300
    settings["h"] = settings["h"] or 120

    local fr = Ben_Derma.Frame(settings)

    local b, txt
    local slid = Ben_Derma.Slider({
        ["parent"] = fr,
        ["w"] = fr:GetWide()-10,
        ["x"] = 5,
        ["y"] = 35,
        ["min"] = settings["min"],
        ["max"] = settings["max"],
        ["decimals"] = settings["decimals"],
    })
    function slid:OnValueChanged(new)
        txt:SetValue(new)
        b:GetSettingsTable()["text"] = fr:ButtonText(new)
    end

    txt = Ben_Derma.TextEntry({
        ["parent"] = fr,
        ["text"] = settings["placeholerMinMax"],
        ["w"] = fr:GetWide()-10,
        ["x"] = 5,
        ["y"] = 60,
    })
    function txt:OnValueChanged(new)
        local n = tonumber(new)
        if n and slid:GetValue() != n then
            slid:SetValue(n)
        end
    end

    b = Ben_Derma.Button({
        ["parent"] = fr,
        ["w"] = fr:GetWide()-10,
        ["x"] = 5,
        ["y"] = 90,
    })
    function b:Click()
        fr:Click(slid:GetValue())
        fr:Remove()
    end

    timer.Simple(0, function()
        if !IsValid(slid) then return end
        slid:OnValueChanged(slid:GetValue())
    end)

    return fr
end