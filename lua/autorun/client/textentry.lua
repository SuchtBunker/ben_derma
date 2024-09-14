-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

local COLOR_TEXT_PLACEHOLDER = ColorAlpha(Ben_Derma["COLOR_TEXT"],150)
function Ben_Derma.TextEntry(settings)
	settings = settings or {}
	settings["w"] = settings["w"] or 100
	settings["h"] = settings["h"] or 25
	settings["font"] = settings["font"] or "Font_20"

	local p = Ben_Derma.SubPanel({
		["parent"] = settings["parent"],
		["x"] = settings["x"],
		["y"] = settings["y"],
		["w"] = settings["w"],
		["h"] = settings["h"],
	})

	local txt = vgui.Create("DTextEntry",p)
	txt:SetSize(p:GetWide()-2,p:GetTall())
	txt:SetPos(2,0)
	txt:SetFont(settings["font"])
	txt:SetMultiline(settings["multiline"] == true)
	function txt:Paint(w,h)
		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)

		if settings["text"] then
			if self:GetValue() == "" and !self:IsEditing() then
				surface.SetFont(self:GetFont())
				surface.SetTextColor(COLOR_TEXT_PLACEHOLDER)
				surface.SetTextPos(5,2.5)
				surface.DrawText(settings["text"])
			end
		end

		self:DrawTextEntryText(Ben_Derma["COLOR_TEXT"],Ben_Derma["COLOR_ACCENT"],Ben_Derma["COLOR_TEXT"])
	end

	function p:SetNumeric(v) txt:SetNumeric(v) end
	function p:SetValue(v) txt:SetValue(v) end
	function p:SetFont(v) txt:SetFont(v) end
	function p:GetValue() return txt:GetValue() end
	function p:GetFont() return txt:GetFont() end
	function p:IsEditing() return txt:IsEditing() end
	function p:SetMultiline(b) txt:SetMultiline(b) end
	function p:RequestFocus() txt:RequestFocus() end
	function p:PerformLayout(w,h) txt:SetSize(w,h) end

	txt:SetUpdateOnType(true)
	function txt:OnValueChange(val)
		if p.OnValueChanged then
			p:OnValueChanged(val)
		end
	end

	function p:GetSettingsTable() return settings end
	return p
end
