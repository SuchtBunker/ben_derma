-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

Ben_Derma = Ben_Derma or {}

Ben_Derma["COLOR_ACCENT"] = Color(252,98,3) //Color(0,100,245)
Ben_Derma["COLOR_ACCENT_DEF"] = table.Copy(Ben_Derma["COLOR_ACCENT"])

Ben_Derma["COLOR_BLUR_BACKGROUND"] = Color(30,30,30,50)
Ben_Derma["COLOR_BAR"] = Color(0,0,0,50)

Ben_Derma["COLOR_OUTLINE"] = Color(0,0,0,100)
Ben_Derma["COLOR_KNOB"] = Color(135,135,135,150)
Ben_Derma["COLOR_TEXT"] = Color(255,255,255)

Ben_Derma["COLOR_3D2DPanelBG"] = Color(50,50,50,150)

Ben_Derma["BlurMult"] = 7

Ben_Derma["SOUND_HOVER"] = "UI/buttonrollover.wav"
Ben_Derma["SOUND_CLICK"] = "UI/buttonclick.wav"

COLOR_WHITE = Color(255,255,255)
COLOR_ORANGE = Color(255,140,0)
COLOR_BLACK = Color(0,0,0)
COLOR_RED = Color(255,0,0)
COLOR_GREEN = Color(0,255,0)
COLOR_BLUE = Color(0,0,255)
COLOR_DARKBLUE = Color(50,50,150)
COLOR_TURQUOISE = Color(3, 223, 252)
COLOR_PURPLE = Color(100,0,255)
COLOR_PINK = Color(255,0,255)

local fonts = {}
Ben_Derma["Fonts"] = fonts
for i=1, 80 do
	local s = i * 2.5
	table.insert(fonts,s)
end
for k,v in ipairs(fonts) do
	surface.CreateFont("Font_"..v,{
		font = "Expressway Rg",//"Motion Control", //"Sublime",
		size = v,
		weight = 500,
	})
end

MaxDist3D2D = 250^2

// SETTINGS
Ben_Derma.Settings = util.JSONToTable(file.Read("Ben_Derma_Settings.txt") or "{}") or {}
hook.Add("Initialize","Ben_Derma:Settings",function()
	for k,v in pairs(Ben_Derma.Settings) do
		hook.Run("Ben_Derma:SettingValueChanged",k,v)
	end
	hook.Run("Ben_Derma:SettingsInitialized")
end)
function Ben_Derma.GetSetting(uid,def)
	local val = Ben_Derma.Settings[uid]
	if val == nil then return def end
	return val
end

hook.Add("Think","Ben_Derma:AccentColor",function()
	local col = hook.Run("Ben_Derma:ChooseColor")
	if !col then
		if !Ben_Derma.GetSetting("Accent_DefaultColor") then
			col = Ben_Derma.GetSetting("Accent_Color")
		end
		if !col then 
			col = Ben_Derma["COLOR_ACCENT_DEF"]
		end
	end

	Ben_Derma["COLOR_ACCENT"] = col
end)

function Ben_Derma.SetSetting(uid,val)
	Ben_Derma.Settings[uid] = val
	hook.Run("Ben_Derma:SettingValueChanged",uid,val)
	file.Write("Ben_Derma_Settings.txt",util.TableToJSON(Ben_Derma.Settings))
end

/*
local fonts = {}
local doFolder
local c = 0
function doFolder(folder)
	local files, folders = file.Find(folder.."*","DATA")
	for k,v in ipairs(files) do
		local txt = file.Read(folder..v,"DATA")
		local len = #txt
		local last = 1

		while true do
			local startP, endP = string.find(txt,"Font_",last)
			if startP then
				last = endP
				c = c + 1
				fonts[string.sub(txt,startP,endP+3)] = (fonts[string.sub(txt,startP,endP+3)] or 0) + 1
			else
				break
			end
		end
	end
	for k,v in ipairs(folders) do
		doFolder(folder..v.."/")
	end
end
doFolder("test/")
print(c)
PrintTable(fonts)
*/