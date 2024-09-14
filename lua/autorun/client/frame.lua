-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

local menuTalking = false
local menuTalkingKey = -1

hook.Add("PlayerButtonDown", "Ben_Derma:MenuTalking", function(ply, btn)
	if btn != menuTalkingKey then return end

	menuTalking = true
end)

hook.Add("PlayerButtonUp", "Ben_Derma:MenuTalking", function(ply, btn)
	if btn != menuTalkingKey then return end

	menuTalking = false
	permissions.EnableVoiceChat(false)
end)

function Ben_Derma.MenuTalkingFrameThink(self)
	local bindedKey = input.LookupBinding("voicerecord")
	if !bindedKey then return end
	
	menuTalkingKey = input.GetKeyCode(bindedKey)
	local isTalking = input.IsKeyDown(menuTalkingKey) and vgui.GetKeyboardFocus() == self
	if isTalking != menuTalking then
		menuTalking = isTalking
		permissions.EnableVoiceChat(menuTalking)
	end 
end

function Ben_Derma.Frame(settings)
	settings = settings or {}
	settings["w"] = settings["w"] or 300
	settings["h"] = settings["h"] or 300
	settings["x"] = settings["x"] or ScrW()/2 - settings["w"]/2
	settings["y"] = settings["y"] or ScrH()/2 - settings["h"]/2

	settings["closeKeys"] = settings["closeKeys"] or {KEY_ESCAPE}

	local fr = vgui.Create("DFrame")
	fr:SetSize(settings["w"] or 300,settings["h"] or 300)
	if settings["dontPopup"] != true then fr:MakePopup() end
	fr:SetPos(settings["x"],settings["y"])
	fr["start"] = SysTime()

	-- Drawing the frame
	function fr:Paint(w,h)
		if self.PrePaint then if self:PrePaint(w,h) == false then return end end

		if settings["backgroundBlur"] then
			Derma_DrawBackgroundBlur(self,self["start"])
		end

		Ben_Derma.DrawBlurPanel(self)

		surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
		surface.DrawRect(0,0,w,30)

		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)
		surface.DrawLine(0,30,w,30)

		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		surface.DrawRect(1,1,2,29)

		if settings["text"] then
			surface.SetFont("Font_25")
			surface.SetTextColor(Ben_Derma["COLOR_TEXT"])
			surface.SetTextPos(10,2.5)
			surface.DrawText(settings["text"])
		end

		if self.PostPaint then self:PostPaint(w,h) end
	end

	-- Remove Parent Panels we dont need
	fr.btnClose:Remove()
	fr.btnMaxim:Remove()
	fr.btnMinim:Remove()
	fr.lblTitle:Remove()

	-- Subframing
	local par = settings["parent"]
	if par then
		par:SetVisible(false)
		par.ParentFrame = fr
	end
	function fr:OnRemove()
		if self.ExtraOnRemove then self:ExtraOnRemove() end
		
		if IsValid(settings["bindToPlayer"]) then
			settings["bindToPlayer"]:RemoveCallOnRemove(fr["menuIdentifier"])
		end

		if par and IsValid(par) and par.ParentFrame == self then
			par:SetVisible(true)
		end
	end

	-- New Layout function
	function fr:PerformLayout()
		local btn_Close = self.btn_Close
		if IsValid(btn_Close) then
			btn_Close:SetPos(self:GetWide()-btn_Close:GetWide()-5,5)
		end
	end


	function fr:CheckCloseKeyDown()
		local keys = settings["closeKeys"]
		if keys then
			for k,v in ipairs(keys) do
				if input.IsKeyDown(v) then
					return true	
				end
			end
		end
		return false
	end
	local wasDown = fr:CheckCloseKeyDown()

	-- Removing some stuff we dont need and changing the grab-bar size
	function fr:Think()
		if settings["noTalk"] != true then
			Ben_Derma.MenuTalkingFrameThink(self)
		end

		if settings["closeable"] != false then
			local wp = vgui.GetWorldPanel()
			local mp = vgui.GetKeyboardFocus()
			while mp and mp:GetParent() and mp:GetParent() != wp do
				mp = mp:GetParent()
			end

			local isDown = self:CheckCloseKeyDown()
			if isDown then
				if !wasDown and mp == self then
					self.RemovedByKey = true
					self:Remove()
					return
				end
				wasDown = true
			elseif wasDown then
				wasDown = false
			end
		end

		if self.ExtraThink then self:ExtraThink() end
		
		local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
		local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

		if ( self.Dragging ) then
			local x = mousex - self.Dragging[1]
			local y = mousey - self.Dragging[2]

			-- Lock to screen bounds if screenlock is enabled
			if ( self:GetScreenLock() ) then
				x = math.Clamp( x, 0, ScrW() - self:GetWide() )
				y = math.Clamp( y, 0, ScrH() - self:GetTall() )
			end

			self:SetPos( x, math.max(0,y) )
		end

		local screenX, screenY = self:LocalToScreen( 0, 0 )
		if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 30 ) && mousex < (screenX + self:GetWide() - 35)) then
			self:SetCursor( "sizeall" )
			return
		end

		self:SetCursor( "arrow" )
	end

	if settings["closeable"] != false then
		-- Close button
		local b = Ben_Derma.Button({
			["parent"] = fr,
			["w"] = 20,
			["h"] = 20,
			["type"] = 0,
		})
		function b:Paint(w,h)
			surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
			surface.DrawLine(0,0,w,h)
			surface.DrawLine(w,0,0,h)
		end
		function b:Click()
			fr:Remove()
		end
		fr.btn_Close = b
	end

	if settings["bindToPlayer"] then
		fr["menuIdentifier"] = "DFrame_"..os.clock()
		settings["bindToPlayer"]:CallOnRemove(fr["menuIdentifier"],function()
			if IsValid(fr) then fr:Remove() end
		end)
	end

	function fr:GetSettingsTable() return settings end
	return fr
end