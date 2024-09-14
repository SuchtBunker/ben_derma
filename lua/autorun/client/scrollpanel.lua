-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.ScrollPanel(settings)
	settings = settings or {}
	settings["w"] = settings["w"] or 100
	settings["h"] = settings["h"] or 100
	settings["x"] = settings["x"] or 5
	settings["w"] = settings["w"] or 0

	settings["spaceX"] = settings["spaceX"] or 5
	settings["spaceY"] = settings["spaceY"] or 5

	local p = vgui.Create("DPanel",settings["parent"])
	p:SetPos(settings["x"],settings["y"])
	p:SetSize(settings["w"],settings["h"])

	local wasDownLast = false
	function p:Paint(w,h)
		surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
		surface.DrawRect(w-2,0,2,h)

		local canvas = self.Canvas
		local barH = (h/canvas:GetTall()) * h
		local scrollPerc = canvas:GetScroll()/canvas:GetTall()
		local barX, barY = w-2, scrollPerc*h

		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		surface.DrawRect(barX,barY,2,barH)

		local mX, mY = self:ScreenToLocal(gui.MouseX(),gui.MouseY())

		local isDown = input.IsMouseDown(MOUSE_LEFT)

		if isDown and self.MovingBar then
			local newScrollPerc = mY/h
			local addPerc = h/canvas:GetTall()
			self:SetScroll((newScrollPerc - addPerc/2) * canvas:GetTall() )
		else
			if mX < barX or mX > w then // Is not in X - range of that bar thing
				self:SetCursor("arrow")
				self.MovingBar = nil
			else
				self:SetCursor("hand")
				if !wasDownLast then
					self.MovingBar = true
				end
			end
		end

		wasDownLast = isDown
	end

	local canvas = vgui.Create("DPanel",p)
	canvas:SetPos(0,0)
	canvas:SetSize(settings["w"]-7,settings["h"])
	p.Canvas = canvas
	function canvas:Paint() end
	function canvas:PerformLayout(w,h)
		local w = p:GetWide()-7
		local children = self:GetChildren()
		local canvasH = 0

		if settings["autoResizeChildrenToW"] then
			for i=1, #children do
				local child = children[i]
				child:SetWide(w)
				child:SetPos(0,canvasH)
				canvasH = canvasH + child:GetTall() + settings["spaceY"]
				child:InvalidateLayout(true)
			end
			canvasH = canvasH - settings["spaceY"] // Remove last space as there is no other children after the last
		else
			local lineH = 0
			local lineW = 0
			for i=1, #children do
				local firstInLine = lineW == 0

				local child = children[i]
				if child:GetWide() > w then
					child:SetWide(w)
				end

				if !firstInLine and (lineW + child:GetWide()) > w then // NEXT LINE
					canvasH = canvasH + lineH + settings["spaceY"]
					lineW = 0
					lineH = 0
				end

				child:SetPos(lineW,canvasH)
				lineW = lineW + child:GetWide() + settings["spaceX"]
				lineH = math.max(lineH,child:GetTall())
			end
			if lineW != 0 then
				canvasH = canvasH + lineH//- settings["spaceY"] // Remove last space as there is no other children after the last
			end
		end
		self:SetSize(w,canvasH)
	end
	canvas.Scroll = 0

	// Scrolling
	function canvas:SetScroll(px)
		local size = self:GetTall() - p:GetTall()
		if size > 0 then
			local px = math.Clamp(px,0,size)
			self.Scroll = px
			self:SetPos(0,-px)
		else
			self:SetPos(0,0)
		end
	end
	function p:SetScroll(v) canvas:SetScroll(v) end
	
	function canvas:AddScroll(px)
		self:SetScroll(self:GetScroll() + px)
	end
	function p:AddScroll(v) canvas:AddScroll(v) end

	function canvas:GetScroll()
		return self.Scroll or 0
	end
	function p:GetScroll() return canvas:GetScroll() end
	
	function canvas:GetScrollPerc()
		return self.Scroll/(self:GetTall() - p:GetTall())
	end
	function p:GetScrollPerc() return canvas:GetScrollPerc() end

	function p:OnMouseWheeled(delta)
		self:AddScroll(delta * -1 * 25)
	end

	// Add Panel
	function canvas:Add(child,pos)
		if pos then
			local set = false
			local t = table.Copy(self:GetChildren())
			for k,v in ipairs(t) do
				v:SetParent()
			end
			table.insert(t,pos,child)
			for k,v in ipairs(t) do
				v:SetParent(self)
			end
		else
			child:SetParent(self)
		end

		self:InvalidateLayout(true)
	end
	function p:Add(child,pos)
		canvas:Add(child,pos)
	end

	// Clear Panels
	function canvas:Clear(start)
		self:SetScroll(0)
		
		local children = self:GetChildren()
		for i=(start or 1), #children do
			children[i]:Remove()
		end

		self:InvalidateLayout(true)
	end
	function p:Clear(start)
		self.Canvas:Clear(start)
	end

	function canvas:IsEmpty()
		local childs = self:GetChildren()
		for i=1, #childs do
			if IsValid(childs[i]) then return false end
		end
		return true
	end
	function p:IsEmpty()
		return self.Canvas:IsEmpty()
	end

	function p:GetChildren()
		return self.Canvas:GetChildren()
	end

	function p:PerformLayout(w,h)
		canvas:InvalidateLayout(true)
	end
	function p:GetSettingsTable() return settings end

	function p:ScrollToChild(child)
		local x, y = child:GetPos()
		self:SetScroll(y)
	end

	return p
end