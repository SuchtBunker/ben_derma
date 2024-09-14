-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

COLOR_NOTCLICKABLE = Color(255,255,255,50)

function Ben_Derma.SubPanel(settings)
	settings = settings or {}
	settings["w"] = settings["w"] or 100
	settings["h"] = settings["h"] or 100
	settings["x"] = settings["x"] or 5
	settings["y"] = settings["y"] or 0
	settings["textStartH"] = settings["textStartH"] or 0

	local p = vgui.Create("DPanel",settings["parent"])
	p:SetSize(settings["w"],settings["h"])
	p:SetPos(settings["x"],settings["y"])
	function p:Paint(w,h)
		if self.PrePaint then if self:PrePaint(w,h) == false then return end end

		if self.GreyOut and self:GreyOut() then
			surface.SetDrawColor(COLOR_NOTCLICKABLE)
			surface.DrawRect(0,0,w,h)
		end

		surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
		surface.DrawRect(0,0,w,h)
		if settings["skipAccent"] != true then
			surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
			surface.DrawRect(1,1,2,h-2)
		end
		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)

		if settings["text"] then
			local font = settings["font"] or "Font_25"
			local text = isfunction(settings["text"]) and settings["text"]() or settings["text"]
			if self["lastext"] != text then
				text = settings["dontFormatText"] and stext or Ben_Derma.FormatText(text,font,w-3-10,0)
				self["lastext"] = text
				
				local wide, tall = surface.GetTextSize(text)
				if settings["hToText"] then
					self:SetTall(tall+5+settings["textStartH"])
				end
				if settings["wToText"] then
					self:SetWide(wide+3+10)
				end
			end

			draw.DrawText(text,font,3+5,settings["textStartH"],settings["textcolor"] or Ben_Derma["COLOR_TEXT"])
		end
		
		if self.PostPaint then self:PostPaint(w,h) end
	end
	p:Paint(p:GetWide(),p:GetTall())

	function p:GetSettingsTable() return settings end
	return p
end