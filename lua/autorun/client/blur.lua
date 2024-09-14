-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

Ben_Derma.Blurs = {
	{
		["Name"] = "Blur (Beeinflusst Performance)",
		["URL"] = true,
	},
	{
		["Name"] = "Poly-Blau",
		["URL"] = "https://i.imgur.com/8jzF0CI.jpg",
	},
	{
		["Name"] = "Grau",
		["URL"] = "https://i.imgur.com/zaMTkWj.png",
	},
	{
		["Name"] = "Farbig",
		["URL"] = "https://i.imgur.com/DKF0DPI.jpg",
	},
	{
		["Name"] = "Hell",
		["URL"] = "https://i.imgur.com/B57WVUB.jpg",
	},
	{
		["Name"] = "Hell Blau",
		["URL"] = "https://i.imgur.com/30wiR7k.jpg",
	},
	{
		["Name"] = "Dunkel Blau/Rot",
		["URL"] = "https://i.imgur.com/RMmFY0J.jpg",
	},
	{
		["Name"] = "Hell Lila",
		["URL"] = "https://i.imgur.com/4Y4RzTN.jpg",
	},
	{
		["Name"] = "Custom",
		["URL"] = false,
	},
}

local byURL = {}
for k,v in ipairs(Ben_Derma.Blurs) do
	byURL[v["URL"]] = true
end

hook.Add("F4:Settings","BlurMat",function(List,ofr)
	local p = Ben_Derma.SubPanel({
		["text"] = "Design-Hintergrund",
		["h"] = 85,
	})
	List:Add(p)

	local ops = {}
	for k,v in ipairs(Ben_Derma.Blurs) do
		ops[k] = {
			["text"] = v["Name"],
			["value"] = v["URL"],
		}
	end

	local cb = Ben_Derma.ComboBox({
		["parent"] = p,
		["w"] = p:GetWide()-13,
		["y"] = 30,
		["x"] = 8,
		["options"] = ops,
	})
	local url = Ben_Derma.GetSetting("background")
	cb:SetValue(byURL[url] and url or false)
	function cb:OnValueChanged(new)
		if new then
			Ben_Derma.SetSetting("background",new)
		else
			local fr = Ben_Derma.Frame({
				["parent"] = ofr,
				["text"] = "Design-Hintergrund",
				["w"] = 300,
				["h"] = 95,
			})

			local tb = Ben_Derma.TextEntry({
				["parent"] = fr,
				["text"] = "URL (PNG/JPG)",
				["w"] = fr:GetWide()-10,
				["x"] = 5,
				["y"] = 35,
			})

			local b = Ben_Derma.Button({
				["parent"] = fr,
				["text"] = "Hintergrund setzen",
				["w"] = fr:GetWide()-10,
				["x"] = 5,
				["y"] = 65,
			})
			function b:Click()
				Ben_Derma.SetSetting("background",tb:GetValue())
				fr:Remove()
			end
		end
	end
	
	local slid = Ben_Derma.Slider({
		["parent"] = p,
		["x"] = 8,
		["y"] = 60,
		["w"] = p:GetWide()-13,
		["start"] = Ben_Derma.GetSetting("background_alpha") or 255,
		["min"] = 0,
		["max"] = 255,
	})
	function slid:OnValueChanged(new)
		Ben_Derma.SetSetting("background_alpha",new)
	end
end)

--
local bgMat
hook.Add("Ben_Derma:SettingValueChanged","Background",function(key,val)
	if key != "background" then return end
	if !isstring(val) then return end

	local ext = string.Right(val,4)
	local fileName = hash.MD5(val)..ext

	local mat = Material("../data/"..fileName)
	if mat:IsError() then
		http.Fetch(val,function(res)
			file.Write(fileName,res)
			bgMat = Material("../data/"..fileName)
		end)
	else
		bgMat = mat
	end
end)

local matBlurScreen = Material( "pp/blurscreen" )
local function actualDraw(x,y,w,h,startU,startV,endU,endV,bg)
	local alpha = Ben_Derma.GetSetting("background_alpha") or 255
	if alpha > 0 then
		local curBG = Ben_Derma.GetSetting("background")
		if curBG == true or curBG == nil then
			alpha = alpha / 25
			surface.SetMaterial(matBlurScreen)
			surface.SetDrawColor(255,255,255,255)

			for i=0.33, 1, 0.33 do
				matBlurScreen:SetFloat( "$blur", alpha * i )
				matBlurScreen:Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRectUV(x,y,w,h,startU,startV,endU,endV)
			end
		else
			if bgMat then
				surface.SetMaterial(bgMat)
				surface.SetDrawColor(255,255,255,alpha)
				surface.DrawTexturedRectUV(x,y,w,h,startU,startV,endU,endV)
			end
		end
	end

	surface.SetDrawColor(bg or Ben_Derma["COLOR_BLUR_BACKGROUND"])
	surface.DrawRect(x,y,w,h)
end

function Ben_Derma.DrawBlurPanel(panel)
	local x, y = panel:LocalToScreen(0,0)
	local w, h = panel:GetWide(), panel:GetTall()
	local scrw, scrh = ScrW(), ScrH()

	actualDraw(0,0,w,h,x/scrw,y/scrh,(x+w)/scrw,(y+h)/scrh)
end

function Ben_Derma.DrawBlur(x,y,w,h,bg)
	local scrw, scrh = ScrW(), ScrH()

	actualDraw(x,y,w,h,x/scrw,y/scrh,(x+w)/scrw,(y+h)/scrh,bg)
end

/*
local matBlurScreen = Material("pp/blurscreen")
local rt = GetRenderTarget("Ben_Derma Blur",ScrW(),ScrH(),true)

local rtMat = CreateMaterial("Ben_Derma Blur "..os.time(),"UnlitGeneric",{
	["$basetexture"] = rt:GetName(),
	["$translucent"] = 1
})

hook.Add("PreRender","Blur Render",function()
	//if true then return end
	render.PushRenderTarget(rt)
		cam.Start2D()
			surface.SetMaterial( matBlurScreen )
			surface.SetDrawColor( 255, 255, 255, 255 )

			for i=0.33, 1, 0.33 do
				matBlurScreen:SetFloat( "$blur", 4 * 5 * i )
				matBlurScreen:Recompute()
				if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
				surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			end
		cam.End2D()
	render.PopRenderTarget()

	//local mult = hook.Run("Ben_Derma:BlurMult") or Ben_Derma["BlurMult"]
	local mult = 1
	//render.BlurRenderTarget(rt, mult, mult, 1)
end)
*/