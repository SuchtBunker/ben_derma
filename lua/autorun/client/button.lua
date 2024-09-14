-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

COLOR_BTN = Ben_Derma["COLOR_BAR"]

COLOR_BTN_HOVER = table.Copy(Ben_Derma["COLOR_BAR"])
COLOR_BTN_HOVER.r = COLOR_BTN_HOVER.r + 75
COLOR_BTN_HOVER.g = COLOR_BTN_HOVER.g + 75
COLOR_BTN_HOVER.b = COLOR_BTN_HOVER.b + 75

COLOR_BTN_PRESS = table.Copy(Ben_Derma["COLOR_BAR"])
COLOR_BTN_PRESS.r = COLOR_BTN_PRESS.r + 100
COLOR_BTN_PRESS.g = COLOR_BTN_PRESS.g + 100
COLOR_BTN_PRESS.b = COLOR_BTN_PRESS.b + 100

function Ben_Derma.Button(settings)
	local settings = settings or {}
	settings["w"] = settings["w"] or 100
	settings["h"] = settings["h"] or 25
	settings["x"] = settings["x"] or 5
	settings["y"] = settings["y"] or 0
	settings["type"] = settings["type"] or 2
	settings["font"] = settings["font"] or "Font_25"
	// settings["textcolor"] = settings["textcolor"] or Ben_Derma["COLOR_TEXT_ON_ACCENT"] // NOT DOING THIS TO MAKE THE COLOR CHANGE AVAILABLE WHILE MENU BEING OPEN 

	local b = vgui.Create("DButton",settings["parent"])
	b:SetSize(settings["w"],settings["h"])
	b:SetPos(settings["x"],settings["y"])
	b:SetText("")
	b:SetDoubleClickingEnabled(false)
	function b:ClickFailed(why)
		if isstring(why) then
			Notify(why,NOTIFY_ORANGE,5)
		end
	end
	function b:Paint(w,h)
		if self.PrePaint then if self:PrePaint(w,h) == false then return end end

		if self.GreyOut and self:GreyOut() then
			surface.SetDrawColor(COLOR_NOTCLICKABLE)
			surface.DrawRect(0,0,w,h)
		end
		
		if self["Clicked"] > CurTime() then
			surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
			surface.DrawRect(0,0,w,h)
		else
			local clickable = self.Clickable == nil or self:Clickable() == true

			local btnType = settings["type"]
			if btnType == 1 then
				surface.SetDrawColor(clickable and self:IsHovered() and (self:IsDown() and COLOR_BTN_PRESS or COLOR_BTN_HOVER) or COLOR_BTN)
				surface.DrawRect(0,0,w,h)
			elseif btnType == 2 then
				surface.SetDrawColor(clickable and self:IsHovered() and (self:IsDown() and COLOR_BTN_PRESS or COLOR_BTN_HOVER) or COLOR_BTN)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
				surface.DrawRect(1,1,2,h-2)
			elseif btnType == 3 then
				surface.SetDrawColor(clickable and self:IsHovered() and (self:IsDown() and COLOR_BTN_PRESS or COLOR_BTN_HOVER) or COLOR_BTN)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
				surface.DrawRect(w-3,1,2,h-2)
			elseif btnType == 4 then
				surface.SetDrawColor(clickable and self:IsHovered() and (self:IsDown() and COLOR_BTN_PRESS or COLOR_BTN_HOVER) or COLOR_BTN)
				surface.DrawRect(0,0,w,h)

				surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
				surface.DrawRect(1,1,2,h-2)
				surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
				surface.DrawRect(w-3,1,2,h-2)
			end
		end

		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)
		
		if settings["text"] then
			draw.SimpleText(settings["text"], settings["font"], settings["textLeft"] and 8 or w/2, h/2, settings["textcolor"] or Ben_Derma["COLOR_TEXT_ON_ACCENT"], settings["textLeft"] and TEXT_ALIGN_LEFT or TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)	
		end
		
		if self.PostPaint then self:PostPaint(w,h) end
	end
	b.WasHovered = false
	function b:Think()
		if self.ExtraThink then self:ExtraThink() end
		
		local hoverNow = self:IsHovered() 
		local hoverLast = self.WasHovered
		if hoverNow != hoverLast then
			self.WasHovered = hoverNow
			surface.PlaySound(Ben_Derma["SOUND_HOVER"])
		end
	end
	b["Clicked"] = 0
	function b:DoClick()
		if self.Clickable then
			local ret = self:Clickable()
			if ret != true then
				if self.ClickFailed then
					self:ClickFailed(ret)
				end 
				return
			end
		end

		if settings["confirm"] then
			if self["Clicked"] < CurTime() then
				self["Clicked"] = CurTime() + 1
				return
			end
		end

		surface.PlaySound(Ben_Derma["SOUND_CLICK"])
		if self.Click then self:Click() end
	end

	function b:GetSettingsTable() return settings end
	return b
end