-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

local collapseSave = {}
function Ben_Derma.Category(settings)
	settings["w"] = settings["w"] or 100
	settings["h"] = 25
	settings["x"] = settings["x"] or 5
	settings["y"] = settings["y"] or 0

	local p = vgui.Create("DPanel",settings["parent"])
	p:SetSize(settings["w"],settings["h"])
	p:SetPos(settings["x"],settings["y"])
	function p:Paint(w,h)
		draw.RoundedBox(0,0,settings["h"],w,h,Ben_Derma["COLOR_BAR"])
		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)
	end

	if settings["expanded"] == nil then
		p.Expanded = collapseSave[settings["uid"]] != false
	else
		p.Expanded = settings["expanded"] == true
	end
	p.Items = {}
	
	local b = Ben_Derma.Button({
		["parent"] = p,
		["x"] = 0,
		["y"] = 0,
		["w"] = p:GetWide(),
		["h"] = settings["h"],
		["text"] = settings["text"],
	})
	function b:Click()
		if p.Expanded then
			p:Collapse()
		else
			p:Expand()
		end
	end

	function p:Add(item)
		table.insert(self.Items,item)
		item:SetParent(self)
		p:InvalidateLayout(true)
	end

	function p:Clear(start)
		for i=#self.Items, 1, -1 do
			local p = self.Items[i]
			if IsValid(p) and (!start or start < i) then
				p:Remove()
				table.remove(self.Items,i)
			end
		end
		p:InvalidateLayout(true)
	end

	function p:Expand()
		local uid = settings["uid"]
		if uid then collapseSave[uid] = true end
 		self.Expanded = true
		self:InvalidateLayout(true)
	end

	function p:Collapse()
		local uid = settings["uid"]
		if uid then collapseSave[uid] = false end
		self.Expanded = false
		self:InvalidateLayout(true)
	end

	function p:PerformLayout(w)
		b:SetWide(w)

		local x, y = 5, 30
		local maxH = 0
		for k,v in ipairs(self.Items) do
			if !IsValid(v) then continue end
			
			if settings["autoResizeChildrenToW"] then
				v:SetWide(self:GetWide()-10)
			end

			if x + v:GetWide() > w then
				x = 5
				y = y + maxH + 5
				maxH = 0
			end

			v:SetPos(x,y)
			maxH = math.max(maxH,v:GetTall())
			x = x + v:GetWide() + 5
		end

		if self.Expanded then
			self:SetHeight(y+maxH+5)
		else
			self:SetHeight(settings["h"])
		end
	end

	function p:GetItems() return self.Items end
	function p:IsEmpty() for k,v in ipairs(self:GetItems()) do if IsValid(v) then return false  end end return true end 

	function p:GetSettingsTable() return settings end
	return p
end