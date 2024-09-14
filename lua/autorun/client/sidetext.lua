-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.SideText(settings)
	surface.SetFont("Font_25")
	local textW, textH = surface.GetTextSize(settings["text"])
	local p = Ben_Derma.SubPanel({
		["parent"] = settings["parent"],
		["w"] = settings["w"] or textW + 12,
		["h"] = settings["h"],
		["x"] = settings["x"],
		["y"] = settings["y"],
		["text"] = settings["text"],
		["textStartH"] = (settings["h"] - textH)/2 + 2,
		["font"] = settings["font"],
		["wToText"] = Either(settings["w"],false,true),
	})

	local parent = settings["realparent"] or settings["parent"]
	function parent:ChangeSideText(text)
		p:GetSettingsTable()["text"] = text
	end
	return p
end