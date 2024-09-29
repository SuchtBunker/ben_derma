-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] -- 

function Ben_Derma.ProgressBar(perc,x,y,w,h,text,font)
	x = x or ScrW()/2
	y = y or ScrH()/2 + 25
	w = w or 150
	h = h or 20

	h = h or 20
	local rX, rY = x-w/2, y-h/2
	local margin = h * .2

	draw.RoundedBox(0,rX,rY,w,h,Ben_Derma["COLOR_BLUR_BACKGROUND"])
	
	surface.SetDrawColor(Ben_Derma["COLOR_OUTLINE"])
	surface.DrawOutlinedRect(rX,rY,w,h)

	rX = rX + margin
	rY = rY + margin
	local nW = w - margin*2
	local nH = h - margin*2
	draw.RoundedBox(0,rX,rY,nW,nH,Ben_Derma["COLOR_BAR"])
	draw.RoundedBox(0,rX,rY,nW*math.min(perc,1),nH,Ben_Derma["COLOR_ACCENT"])

	if text then
		draw.SimpleText(text,font or "Font_15",x,y,COLOR_WHITE,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end