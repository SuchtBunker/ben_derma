-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

local COLOR_RED = Color(255,0,0)
local COLOR_GREEN = Color(0,255,0)
function Ben_Derma.CheckBox(settings)
	settings = settings or {}
	settings["w"] = settings["w"] or 30
	settings["h"] = settings["h"] or 30

	local b = Ben_Derma.Button(settings)
	function b:PostPaint(w,h)
		if self:GetValue() then
		end
	end

	function b:Click()
		self:SetValue(!self:GetValue())
	end

	function b:GetValue()
		return self.Value
	end
	function b:SetValue(b)
		if b != self.Value then
			if self.OnValueChanged then
				self:OnValueChanged(b,self.Value)
			end

			if b then
				settings["text"] = "✓"
				settings["textcolor"] = COLOR_GREEN
			else
				settings["text"] = "✗"
				settings["textcolor"] = COLOR_RED
			end
			self.Value = b
		end
	end
	b:SetValue(settings["start"] == true)

	if settings["sidetext"] then
		local settings = table.Copy(settings)
		settings["parent"] = b
		Ben_Derma.SideText(settings)
	end

	function b:GetSettingsTable() return settings end
	return b
end