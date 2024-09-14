OriginalDermaMenu = OriginalDermaMenu or DermaMenu

local arrowCol = Color(200,200,200)
local function optPaint(self,w,h)
	surface.SetDrawColor(self:IsHovered() and (self:IsDown() and COLOR_BTN_PRESS or COLOR_BTN_HOVER) or COLOR_BTN)
	surface.DrawRect(0,0,w,h)

	draw.SimpleText(self["Name"], "Font_15", 25, 2.5, Ben_Derma["COLOR_TEXT"])

	surface.SetDrawColor(ColorAlpha(Ben_Derma["COLOR_KNOB"],20))
	surface.DrawLine(0, 0, w, 0)

	if self["HasSubMenu"] then
		draw.SimpleText(">", "Font_15", w-15, 2.5, arrowCol)
	end
end

local itemH = 22
local function optPerformLayout(self, w, h)
	surface.SetFont("Font_15")
	self:SetWidth(select(1,surface.GetTextSize(self["Name"])) + 30)

	if self["HasSubMenu"] then
		self:SetWidth(self:GetWide() + 20)
	end
	
	local w = math.max( self:GetParent():GetWide(), self:GetWide() )
	self:SetSize( w, itemH )

	DButton.PerformLayout( self, w, h )
end

local function optAddSubMenu(self, name, func)
	name = name or self["Name"]
	func = func or self["Func"]

	local opt = self["OriginalAddSubMenu"](self, "", func)
	opt["Name"] = name
	opt["HasSubMenu"] = true
	self["HasSubMenu"] = true
	self["SubMenuArrow"]:Remove()

	return opt
end

local function ddAddOption(self, name, func)
	local opt = self["OriginalAddOption"](self, "", func)
	opt["Name"] = name
	opt["Func"] = func
	opt["Paint"] = optPaint
	opt["PerformLayout"] = optPerformLayout

	opt["OriginalAddSubMenu"] = opt["AddSubMenu"]
	opt["AddSubMenu"] = optAddSubMenu

	return opt
end

local function ddAddSubMenu(self, name, func)
	local men, opt = self["OriginalAddSubMenu"](self, "", func)
	opt["Name"] = name
	opt["Func"] = func
	opt["Paint"] = optPaint
	opt["PerformLayout"] = optPerformLayout
	opt["HasSubMenu"] = true
	opt["SubMenuArrow"]:Remove()

	return men, opt
end

local dim = Color(45, 45, 45, 248)
local function ddPaint(self,w,h)
	surface.SetDrawColor(dim)
	surface.DrawRect(0,0,w,h)

	surface.SetDrawColor(Ben_Derma["COLOR_KNOB"])
	surface.DrawOutlinedRect(0,0,w,h)
end

function DermaMenu(...)
	local dd = OriginalDermaMenu(...)
	dd["Paint"] = ddPaint
	dd["OriginalAddOption"] = dd["AddOption"]
	dd["AddOption"] = ddAddOption

	dd["OriginalAddSubMenu"] = dd["AddSubMenu"]
	dd["AddSubMenu"] = ddAddSubMenu

	return dd
end