-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.Switch(settings)
	settings = settings or {}

	local p
	local buttonSettings = table.Copy(settings)
	buttonSettings["w"] = 40
	buttonSettings["h"] = 20
	buttonSettings["text"] = nil

	if settings["text"] then
		settings["w"] = settings["w"] or 150
		settings["h"] = settings["h"] or 20
		settings["x"] = settings["x"] or 5
		settings["y"] = settings["y"] or 0

		buttonSettings["x"] = 0
		buttonSettings["y"] = 0

		p = vgui.Create("DPanel",settings["parent"])
		p:SetSize(settings["w"],settings["h"])
		p:SetPos(settings["x"],settings["y"])
		function p:Paint() end

		buttonSettings["parent"] = p
		
		local sideSettings = table.Copy(settings)
		sideSettings["parent"] = p
		sideSettings["x"] = 49
		sideSettings["font"] = sideSettings["font"] or "Font_20"
		sideSettings["y"] = 0
		sideSettings["w"] = settings["w"] - 49
		
		local sideText = Ben_Derma.SideText(sideSettings)
		function p:PerformLayout(w,h)
			local bW = buttonSettings["w"] + 5
			sideText:SetPos(bW,0)
			sideText:SetSize(w-bW,h)
		end
		p.SideText = sideText
	end

	local b = Ben_Derma.Button(buttonSettings)
	function b:Paint(w,h)
		if self.PrePaint then if self:PrePaint(w,h) == false then return end end
	
		surface.SetDrawColor(self:IsHovered() and (self:IsDown() and COLOR_BTN_PRESS or COLOR_BTN_HOVER) or COLOR_BTN)
		surface.DrawRect(0,0,w,h)

		/*
		if self:GetValue() then
			surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
			surface.DrawRect(0,0,w,h)
		end

		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)
		*/

		local col1 = self:GetValue() and Ben_Derma["COLOR_ACCENT"] or Ben_Derma["COLOR_KNOB"]
		local col2 = self:GetValue() and Ben_Derma["COLOR_KNOB"] or Ben_Derma["COLOR_BAR"]

		local size = (w-2)/2
		surface.SetDrawColor(col1)
		surface.DrawRect(1,1,size,h-2)

		surface.SetDrawColor(col2)
		surface.DrawRect(size+1,1,size,h-2)

		if self:GetValue() then
			surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
			surface.DrawRect(size+1,1,1,h-2)
		end

		if self.PostPaint then self:PostPaint(w,h) end
	end

	function b:Click()
		self:SetValue(!self:GetValue())
	end

	function b:GetValue()
		return self.Value
	end

	function b:SetValue(bool)
		if bool != self.Value then
			if self.OnValueChanged then
				self:OnValueChanged(bool,self:GetValue())
			end
			if p and p.OnValueChanged then
				p:OnValueChanged(bool,self:GetValue())
			end
			self.Value = bool
		end
	end
	b:SetValue(settings["start"] == true)

	if p then
		function p:GetValue() return b:GetValue() end
		function p:SetValue(bool) b:SetValue(bool) end
		function p:GetSettingsTable() return settings end
	else
		function b:GetSettingsTable() return settings end
	end

	return p or b
end