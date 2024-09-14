-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.ConfirmationFrame(settings)
	local settings = settings or {}
	settings["w"] = settings["w"] or 400
	//settings["h"] = settings["h"] or 115
	settings["title"] = settings["title"] or "Sicher?"
	settings["text"] = settings["text"] or "Bist du dir sicher?"
	settings["yestext"] = settings["yestext"] or "Ja"
	settings["font"] = settings["font"] or "Font_25"

	local fr = Ben_Derma.Frame({
		["parent"] = settings["parent"],
		["w"] = settings["w"],
		["h"] = 65,
		["text"] = settings["title"],
		["backgroundBlur"] = true,
	})
	local b = true
	local oThink = fr.Think
	function fr:Think()
		oThink(self)

		if b then b = false return end
		if !self:HasFocus() then self:Remove() end
	end
	fr:MakePopup()

	local p = Ben_Derma.SubPanel({
		["parent"] = fr,
		["w"] = fr:GetWide()-10,
		["hToText"] = true,
		["x"] = 5,
		["y"] = 35,
		["text"] = settings["text"],
		["font"] = settings["font"],
	})
	fr:SetTall(fr:GetTall() + p:GetTall() + 5)

	local b = Ben_Derma.Button({
		["parent"] = fr,
		["text"] = settings["yestext"],
		["w"] = fr:GetWide()-10,
		["x"] = 5,
		["y"] = fr:GetTall()-30,
	})
	function b:Click()
		if fr.OnYes then fr:OnYes() end
		if settings["onYes"] then settings["onYes"]() end
		fr:Remove()
	end
	fr:Center()

	function b:GetSettingsTable() return settings end
	return fr
end