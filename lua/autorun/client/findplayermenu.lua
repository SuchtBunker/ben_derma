-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.FindPlayerFrame(settings)
	local settings = settings or {}
	settings["text"] = settings["title"] or "Spieler auswählen"
	
	local fr = Ben_Derma.Frame(settings)

	local doSearch
	local tb = Ben_Derma.TextEntry({
		["parent"] = fr,
		["text"] = "Suche..",
		["w"] = fr:GetWide()-10,
		["h"] = 25,
		["x"] = 5,
		["y"] = 35,
	})
	function tb:OnValueChanged()
		doSearch()
	end

	local List = Ben_Derma.ScrollPanel({
		["parent"] = fr,
		["w"] = fr:GetWide()-10,
		["h"] = fr:GetTall()-70,
		["x"] = 5,
		["y"] = 65,
		["autoResizeChildrenToW"] = true,
	})

	local localply = LocalPlayer()
	function doSearch()
		List:Clear()
		local str = string.lower(tb:GetValue())
		for k,v in ipairs(player.GetAll()) do
			if v == localply or (str != "" and !string.find(string.lower(v:Name()),str)) then continue end
			if settings["customCheck"] and !settings["customCheck"](v) then continue end
			
			local b = Ben_Derma.Button({
				["text"] = v:Name()
			})
			function b:Click()
				fr:Remove()
				settings["callback"](v)
			end
			List:Add(b)
		end
		
		if List:IsEmpty() then
			local p = Ben_Derma.SubPanel({
				["text"] = "Keinen Spieler gefunden",
				["h"] = 25,
			})
			List:Add(p)
		end
	end
	doSearch()

	return fr
end