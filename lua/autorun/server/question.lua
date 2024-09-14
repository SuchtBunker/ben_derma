-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

module("Question",package.seeall)

Current = Current or {}
CurrentID = CurrentID or 0

util.AddNetworkString("Ben_Derma:AbortQuestion")
function End(id,abort)
	local question = Current[id]
	if !question then return end
	
	timer.Remove("Question_"..CurrentID)
	Current[id] = nil

	if abort then
		net.Start("Ben_Derma:AbortQuestion")
		net.WriteUInt(id,20)
		net.Send(question["Target"])

		question["Abort"] = true
		question["Result"] = 0

		local cb = question["Callback"]
		if cb then
			cb(question)
		end

		return true
	else
		net.Start("Ben_Derma:AbortQuestion")
		net.WriteUInt(id,20)
		net.Send(question["Target"])

		local yes, no = #question["VotesYes"], #question["VotesNo"]
		question["Result"] = yes > no and 1 or no > yes and -1 or 0

		local cb = question["Callback"]
		if cb then
			cb(question)
		end
	end
end

util.AddNetworkString("Ben_Derma:Question")
function CreateSurvey(target,title,text,length,endCB,voteCB)
	local id = CurrentID
	CurrentID = id + 1

	net.Start("Ben_Derma:Question")
	net.WriteString(title)
	net.WriteString(text)
	net.WriteUInt(length,10)
	net.WriteUInt(id,20)
	net.WriteBool(target == true)
	if target == true then
		net.Broadcast()
	else
		net.Send(target)
	end

	local responses = {}
	local isPublic = false
	if target != true then
		if type(target) == "Player" then
			responses[target] = 0
			target = {target}
		else
			for k,v in ipairs(target) do
				responses[v] = 0
			end
		end
	else
		isPublic = true
		target = player.GetAll()
	end

	local question = {
		["Target"] = target,
		["Title"] = title,
		["Text"] = text,
		["Length"] = length,
		["Callback"] = endCB,
		["VoteCallback"] = voteCB,
		["VotesYes"] = {},
		["VotesNo"] = {},
		["IsPublic"] = isPublic,
		["PlayerResponses"] = responses,
		["ID"] = id,
	}
	Current[id] = question
	timer.Create("Question_"..id,length,1,function() End(id) end)

	return question
end

net.Receive("Ben_Derma:Question",function(_,ply)
	local id = net.ReadUInt(20)
	local question = Current[id]
	if !question then return end
	
	local responses = question["PlayerResponses"]
	local res = responses[ply]
	if (question["IsPublic"] and res != nil) or (!question["IsPublic"] and res != 0) then return end // not asking this player (anymore)

	local b = net.ReadBool()
	responses[ply] = b and 1 or -1
	table.insert(b and question["VotesYes"] or question["VotesNo"],ply)

	if question["VoteCallback"] then
		question["VoteCallback"](question,ply)
	end

	if (#question["VotesYes"] + #question["VotesNo"]) == #question["Target"] then
		End(id)
	end
end)

net.Receive("Ben_Derma:AbortQuestion",function(_,ply)
	local id = net.ReadUInt(20)

	if !Admin.HasPlayerAccess(ply,"stopvotes") then return end

	if End(id,true) then
		Notify(true,ply:Name().." hat die Abstimmung "..id.." abgebrochen!",NOTIFY_BLUE,5)
	end
end)

local function cb(ply,_,args)
	local id = tonumber(args)
	if !id then return end

	if !Admin.HasPlayerAccess(ply,"stopvotes") then return end

	if End(id,true) then
		Notify(true,ply:Name().." hat die Abstimmung "..id.." abgebrochen!",NOTIFY_BLUE,5)
	end
end
Command.Add("cancelvote",cb)
Command.Add("stopvote",cb)