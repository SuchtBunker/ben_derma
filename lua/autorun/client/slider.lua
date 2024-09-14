-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.Slider(settings)
	settings = settings or {}
	settings["w"] = settings["w"] or 150
	settings["h"] = settings["h"] or 22
	settings["x"] = settings["x"] or 5
	settings["y"] = settings["y"] or 0

	settings["min"] = settings["min"] or 0
	settings["max"] = settings["max"] or 1

	local p = vgui.Create("DButton",settings["parent"])
	p:SetSize(settings["w"],settings["h"])
	p:SetPos(settings["x"],settings["y"])
	p:SetText("")
	function p:Paint(w,h)
		local slideX = self:GetSlideX()

		surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
		surface.DrawRect(1,1,w-2,h-2)

		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		surface.DrawRect(1,1,slideX,h-2)

		surface.SetDrawColor(Ben_Derma["COLOR_KNOB"])
		surface.DrawRect(slideX+1,1,h-2,h-2)

		if slideX != 0 then
			surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
			surface.DrawRect(slideX+1,1,1,h-2)
		end
		
		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)
	end

	// Knob
	function p:Think()
		if !self:IsDown() and !p:IsDown() then return end

		local x = p:ScreenToLocal(gui.MouseX()-settings["h"]/2,0)
		local w = p:GetWide()-settings["h"]
		local slide = math.Clamp(x,0,w)
		self:SetSlideX(slide/w)
	end

	function p:GetSlideX()
		return self.SlideX or 0
	end

	function p:SetSlideX(perc,dontCallHook)
		local perc = math.Clamp(perc,0,1)
		local w = self:GetWide()-settings["h"]
		local oldVal = self:GetValue()
		self.SlideX = w*perc
		self:InvalidateLayout(true)
		if self.OnValueChanged and !dontCallHook then
			self:OnValueChanged(self:GetValue(),oldVal)
		end
	end

	function p:GetValue()
		local w = self:GetWide()-settings["h"]
		local mult = (settings["max"] - settings["min"])/w
		local val = settings["min"] + (mult * self:GetSlideX())
		local decimals = settings["decimals"]
		if decimals then
			return math.Round(val,decimals)	
		else
			return val
		end
	end

	function p:SetValue(val)
		local diff = (settings["max"] - settings["min"])
		self:SetSlideX((val - settings["min"])/diff)
	end

	if settings["start"] then
		p:SetValue(settings["start"])	
	else
		p:SetValue(settings["min"])
	end

	if settings["sidetext"] then
		local settings = table.Copy(settings)
		settings["parent"] = p
		Ben_Derma.SideText(settings)
	end

	function p:GetSettingsTable() return settings end
	return p
end

/*
local space = 2
local triangle = {
	{ x = space, y = space },
	{ x = 15-space, y = space },
	{ x = 7.5, y = 15-space },
}
local stepSize = 5
function Ben_Derma.Slider(settings)
	settings = settings or {}

	local function translatePercToValue(val)
		local min = (settings["min"] or 0)
		local max = (settings["max"] or 1) - min

		return (val * max) + min
	end
	local function translateValueToPerc(val)
		local max = (settings["max"] or 1)
		local min = (settings["min"] or 0)
		local valNew = val - min
		return valNew/max
	end

	local p = Ben_Derma.SubPanel({
		["parent"] = settings["parent"],
		["w"] = settings["w"] or 100,
		["h"] = settings["h"] or 25,
		["x"] = settings["x"],
		["y"] = settings["y"],
	})

	local slid = vgui.Create("DSlider",p)
	slid:SetSize(p:GetWide()-15-1,20)
	slid:SetWide(slid:GetWide()-(slid:GetWide()%stepSize)+1)
	slid:SetPos(7.5 + 3,0)

	function slid.Knob:Paint(w,h)
		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		draw.NoTexture()
		surface.DrawPoly(triangle)
	end

	function slid:Paint(w,h)
		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		local x = 0
		while x < w do
			surface.DrawRect(x,h-5,1,5)
			x = x + stepSize
		end
	end

	function slid:Think()
		local nowValue = p:GetValue()
		local lastValue = p.LastValue

		if lastValue == nil then p.LastValue = nowValue return end

		if nowValue != lastValue then
			if p.OnValueChanged then
				p:OnValueChanged(nowValue,lastValue)
			end
			p.LastValue = nowValue
		end
	end

	function p:GetValue()
		return translatePercToValue(slid:GetSlideX())
	end

	function p:SetValue(val)
		slid:SetSlideX(translateValueToPerc(val))
	end

	if settings["start"] then
		p:SetValue(settings["start"])	
	end

	return p
end
*/