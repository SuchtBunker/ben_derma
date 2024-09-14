-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

local currentQuestions = {}
local currentQuestionsByID = {}
local function reposAll()
	local fullH = 20
	for k,v in ipairs(currentQuestions) do
		fullH = fullH + v:GetTall() + 5
	end

	local y = ScrH()/2-fullH
	for k,v in ipairs(currentQuestions) do
		v:SetPos(5,y)
		y = y + v:GetTall() + 5
	end
end

function Ben_Derma.RemoveQuestion(id)
	local p = currentQuestionsByID[id]
	if IsValid(p) then
		p:Remove()
	end
end

function Ben_Derma.Question(settings)
	Ben_Derma.RemoveQuestion(settings["id"] or "")

	surface.PlaySound("Resource/warning.wav")
	
	settings["textYes"] = settings["textYes"] or "Ja"
	settings["textNo"] = settings["textNo"] or "Nein"
	settings["title"] = (settings["title"] or "Frage")..(settings["server"] and settings["isPublic"] and " ("..settings["id"]..")" or "")
	settings["text"] = Ben_Derma.FormatText(settings["text"] or "Ja oder nein?","Font_15",190,0)
	settings["length"] = settings["length"] or 10
	local endTime = CurTime() + settings["length"]

	surface.SetFont("Font_15")
	local tW, tH = surface.GetTextSize(settings["text"])
	local h = 30 + tH + 30
	local p = vgui.Create("DPanel")
	p:SetSize(200,h)
	p:SetPos(5,0)
	function p:OnRemove()
		table.RemoveByValueI(currentQuestions,self)
		reposAll()
	end

	function p:Paint(w,h)
		local ct = CurTime()
		if endTime < ct then
			self:Remove()
			return
		end

		Ben_Derma.DrawBlurPanel(self)

		surface.SetDrawColor(Ben_Derma["COLOR_BAR"])
		surface.DrawRect(0,0,w,25)

		surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
		surface.DrawOutlinedRect(0,0,w,h)
		surface.DrawLine(0,25,w,25)

		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		surface.DrawRect(1,1,2,24)

		surface.SetFont("Font_20")
		surface.SetTextColor(Ben_Derma["COLOR_TEXT"])
		surface.SetTextPos(10,2.5)
		surface.DrawText(settings["title"])

		local perc = (endTime-ct)/settings["length"]
		surface.SetDrawColor(Ben_Derma["COLOR_ACCENT"])
		local pW = (w-2)*perc
		surface.DrawRect(w-pW-1,25,pW,1)

		draw.DrawText(settings["text"],"Font_15",5,30,COLOR_WHITE)
	end

	local b = Ben_Derma.Button({
		["parent"] = p,
		["text"] = settings["textYes"],
		["font"] = "Font_15",
		["w"] = (p:GetWide()-15)/2,
		["h"] = 20,
		["x"] = 5,
		["y"] = p:GetTall()-25,
	})
	function b:Click()
		if settings["server"] then
			net.Start("Ben_Derma:Question")
			net.WriteUInt(settings["id"],20)
			net.WriteBool(true)
			net.SendToServer()
		end

		local cb = settings["onYesCallback"]
		if cb then
			cb()
		end
		p:Remove()
	end

	local b = Ben_Derma.Button({
		["parent"] = p,
		["text"] = settings["textNo"],
		["font"] = "Font_15",
		["w"] = (p:GetWide()-15)/2,
		["x"] = (p:GetWide()-15)/2 + 10,
		["h"] = 20,
		["y"] = p:GetTall()-25,
	})
	function b:Click()
		if settings["server"] then
			net.Start("Ben_Derma:Question")
			net.WriteUInt(settings["id"],20)
			net.WriteBool(false)
			net.SendToServer()
		end

		local cb = settings["onNoCallback"]
		if cb then
			cb()
		end
		p:Remove()
	end

	if LocalPlayer():IsAdmin() and settings["server"] and settings["isPublic"] then
		p:SetTall(p:GetTall() + 25)
		local b = Ben_Derma.Button({
			["parent"] = p,
			["text"] = "Abstimmung abbrechen",
			["font"] = "Font_15",
			["w"] = p:GetWide()-10,
			["x"] = 5,
			["h"] = 20,
			["y"] = p:GetTall()-25,
		})
		function b:Click()
			local id = settings["id"]
			if id then
				net.Start("Ben_Derma:AbortQuestion")
				net.WriteUInt(id,20)
				net.SendToServer()
			end

			p:Remove()
		end
	end

	table.insert(currentQuestions,p)
	reposAll()

	local id = settings["id"]
	if id then
		currentQuestionsByID[id] = p
	end

	timer.Simple(settings["length"],function() 
		if IsValid(p) then p:Remove() end
	end)

	return p
end

net.Receive("Ben_Derma:Question",function()
	Ben_Derma.Question({
		["title"] = net.ReadString(),
		["text"] = net.ReadString(),
		["length"] = net.ReadUInt(10),
		["id"] = net.ReadUInt(20),
		["isPublic"] = net.ReadBool(),
		["server"] = true,
	})
end)

net.Receive("Ben_Derma:AbortQuestion",function()
	Ben_Derma.RemoveQuestion(net.ReadUInt(20))
end)