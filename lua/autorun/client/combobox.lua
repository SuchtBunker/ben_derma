-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.ComboBox(settings)
	local settings = settings or {}
	settings["h"] = nil
	settings["textLeft"] = true

	local b = Ben_Derma.Button(settings)
	local mainB = b
	function b:PostPaint(w,h)
		settings["text"] = self:GetText()
		settings["textcolor"] = self:GetOption()["color"]

		local tri = {
			{ ["x"] = w-20, ["y"] = 5, },
			{ ["x"] = w-5, ["y"] = 5, },
			{ ["x"] = w-12.5, ["y"] = 20, },
		}

		surface.SetDrawColor(Ben_Derma["COLOR_KNOB"])
		draw.NoTexture()
		surface.DrawPoly(tri)
	end

	b.ValueKey = 1

	function b:GetValue()
		return self:GetOption()["value"]
	end
	function b:SetValue(val)
		for k, v in ipairs(settings["options"]) do
			if v["value"] != val then continue end
			self:SetValueKey(k)
			return k
		end
	end

	function b:GetText()
		return self:GetOption()["text"]
	end

	function b:GetOption()
		return settings["options"][self:GetValueKey()]
	end
	
	function b:GetValueKey()
		return self.ValueKey
	end
	function b:SetValueKey(key)
		if self.OnValueChanged then
			if self:OnValueChanged(settings["options"][key]["value"],self:GetValue()) == false then return end
		end
		self.ValueKey = key
	end

	local p
	function b:Click()
		if IsValid(p) then
			p:Remove()
			return
		end

		local s = #settings["options"] * 26 + 1
		local mS = ScrH()*.60
		local bool = false
		if s > mS then
			s = mS
			bool = true
		end

		local x, y = self:LocalToScreen(0,self:GetTall())
		p = vgui.Create("DPanel")
		p:SetSize(self:GetWide(),s)
		p:SetPos(x,math.min(y,(ScrH() - p:GetTall())))
		p:MakePopup()
		p.painted = false
		function p:Paint(w,h)
			if !IsValid(b) then self:Remove() return end
			
			if !b:IsHovered() then
				if self.painted and vgui.GetKeyboardFocus() != self then
					self:Remove()
					return
				end
				self.painted = true

				if input.IsMouseDown(MOUSE_LEFT) then
					local x, y = self:CursorPos()
					if !(x < w and y < h) then
						self:Remove()
					end
				end
			end

			Ben_Derma.DrawBlurPanel(self)
		end

		local List
		if b then
			List = Ben_Derma.ScrollPanel({
				["parent"] = p,
				["w"] = p:GetWide(),
				["h"] = p:GetTall(),
				["x"] = 0,
				["y"] = 0,
				["spaceY"] = 0,
			})
		end

		for k,v in ipairs(settings["options"]) do
			local btn = Ben_Derma.Button({
				["parent"] = p,
				["text"] = v["text"],
				["w"] = p:GetWide(),
				["x"] = 0,
				["y"] = bool and 0 or (1 + (k-1)*26),
				["textLeft"] = true,
				["textcolor"] = v["color"],
			})
			if bool then List:Add(btn) end

			function btn:Click()
				mainB:SetValueKey(k)
				p:Remove()
			end
		end
	end

	function b:GetSettingsTable() return settings end
	return b
end