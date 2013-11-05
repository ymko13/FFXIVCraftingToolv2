--What is not done:
--1. Item Detection (for amount of NQ and HQ items)
--2. End craft prediction 

--Notes:
--For conditions, in SkillView it shows >= but the equivalent code wise in condition is <=

--[[ Create a new table ]]--
CraftingTool={ }

CraftingTool.profilepath = GetStartupPath() .. [[\LuaMods\CraftingTool\Profiles\]];
--[[ Window Settings ]]--
CraftingTool.mainwindow = { name = "CraftingTool", x = 500, y = 200, w = 220, h = 300 }
CraftingTool.smanager = { name = "CraftingTool_SkillManager", x = CraftingTool.mainwindow.x + CraftingTool.mainwindow.w, y = 200, w = 220, h = 300 }
CraftingTool.sbook = { name = "CraftingTool_SkillBook", x = CraftingTool.smanager.x + CraftingTool.smanager.w, y = 200, w = 300, h = 500 }
CraftingTool.sview = { name = "CraftingTool_SkillView", x = 0, y = 0, w = 250, h = 500 }

--[[ Crafting States ]]--
CraftingTool.doNonStopCraft = false --Used for non-stop craft
CraftingTool.doLimitedCraft = false --Used for a limited craft
CraftingTool.craftsLeft = 0 --Shows how many crafts left to do with limited craft

--[[ User Variables for Craft Prediction ]]--
CraftingTool.ProgressGain = 0
CraftingTool.QualityGain = 0
CraftingTool.RecipeLevel = 0

CraftingTool.IQBuffID = 251
CraftingTool.IQStacks = 0

--[[  LookUp Tables  ]]--
CraftingTool.cProf = { --professions table
	["Carpenter"] = { ["id"] = 8, ["init"] = false },
	["Blacksmith"] = { ["id"] = 9, ["init"] = false },
	["Armourer"] = { ["id"] = 10, ["init"] = false },
	["Goldsmith"] = { ["id"] = 11, ["init"] = false },
	["Leatherworker"] = { ["id"] = 12, ["init"] = false },
	["Weaver"] = { ["id"] = 13, ["init"] = false },
	["Alchemist"] = { ["id"] = 14, ["init"] = false },
	["Culinary"] = { ["id"] = 15, ["init"] = false }
}

CraftingTool.cActionType = { --Next Action
	["0"] = "Progress",
	["1"] = "Quality",
	["2"] = "Durability",
	["3"] = "Buff",
	["4"] = "Skip"
}

--[[ Skill List Class]]--
CraftingTool.SkillList = {}
function CraftingTool.SkillList:New( skilllist )
	skilllist = skilllist or { }
	setmetatable(skilllist, self)
	self.__index = self
	return skilllist
end

function CraftingTool.SkillList:Add( value, valuename )
	valuename = valuename or #self + 1
	if(self[valuename] == nil) then
		self[valuename] = value
	else 
		self[valuename.."-"] = value
	end
end

function CraftingTool.SkillList:Remove ( value )
	local uid = value.uid
	for i,e in pairs(self) do
		if(e.uid == uid) then
			e:Destructor()
			table.remove(self,i)
			break
		end
	end
end

function CraftingTool.SkillList:getListPos ( value ) -- works only for skills
	local id = 0
	for i,e in pairs(self) do
		if(e.id == value.id) then
			id = i
			break
		end
	end
	return id
end

function CraftingTool.SkillList:getSkillByUID( skillUID )
	local skill = nil
	
	for i,e in pairs(self) do
		if(e.uid == tonumber(skillUID)) then
			skill = e
			break
		end
	end
	
	return skill
end

function CraftingTool.SkillList:getSkillByName( skillName )
	local skill = nil
	
	for i,e in pairs(self) do
		if(e.name == skillName) then
			skill = e
			break
		end
	end
	
	return skill
end
--[[ End of Skill List Class ]]--

--[[ Basic Skill Class ]]--
CraftingTool.Skill = { -- Can have many params like  ["id"] = 0, ["name"] = "", ["level"] = "", ["cost"] = "", ["actionType"] = "", ["buffid"] = "", ["length"] = "", ["efficiency"] = "", ["chance"] = ""
	WaitTime=0,
	Condition = {},
	on = 0
}

function CraftingTool.Skill:New( skilldetails ) -- Creates a new variable of class CraftingTool.Skill requires skill details leached from Prof.lua files and a boolean stating whether its cross class or not(default false)
	skilldetails = skilldetails or {}
	local conditionlist = {}
	local CC = skilldetails.CC or false
	--d("Creating a new skill")
	
	local uid = tostring(skilldetails.id)
	
	local newuid = uid
	local y = 0
	while not CraftingTool.Profile:IsUniqueSkill(newuid) do
		newuid = uid..tostring(y)
		d(tostring(newuid))
		y = y + 1
	end
	uid = tonumber(newuid)
	
	skilldetails["uid"] = uid
	
	local newskill = deepcopy(CraftingTool.Skill)
	
	for i,e in pairs (skilldetails) do
		newskill[i] = e
	end
	
	return newskill
end

function deepcopy(t)
	if type(t) ~= 'table' then return t end
	local mt = getmetatable(t)
	local res = {}
		for k,v in pairs(t) do
			if type(v) == 'table' then
				v = deepcopy(v)
			end
			res[k] = v
		end
	setmetatable(res,mt)
	return res
end

function CraftingTool.Skill:Destructor()
	self.Condition = {}
end

function CraftingTool.Skill:AddDefConditions(CC) -- Adds default conditions
	if(not CC) then -- If not Cross class then add a level Condition
		self:AddCondition(CraftingTool.Condition:New("level", self.level, "<="))
	end
	if(self.buffid) then --If a buff then add a default notbuff condition
		self:AddCondition(CraftingTool.Condition:New("notbuffid", self.buffid, "None"))
	end
	self:AddCondition(CraftingTool.Condition:New("enoughcp", self.cost, "<="))
end
 
function CraftingTool.Skill:Get( varname ) -- e.g somevar:Get("id") will return the id of this skill
	return self[varname]
end

function CraftingTool.Skill:AddCondition( condition ) --adds a condition to the condition list
	if(self.Condition == nil) then
		self.Condition = {}
	end
	
	if(self:FindCondition(condition.Type, condition.Condition)) then
		if(gDBcadd == "1") then d("Condition already exists, augmenting it's value") end
		self:FindCondition(condition.Type, condition.Condition, condition.Value)
	else
		if(gDBcadd == "1") then d(("Skill ID: %7d"):format((self.id or 0)) .. " TSize: " .. #self.Condition + 1 .. " => " .. ("New condition: ^%s %s %s^"):format(condition.Value, condition.Condition, condition.Type)) end
		table.insert(self.Condition, #self.Condition + 1, condition)
	end
end

function CraftingTool.Skill:FindCondition( Type, Condition, modVal ) -- If you pass modVal then it will modify the value of this condition to modVal and return it to you, otherwise will just return the value of the cond
	local value = nil
	local result = false
	modVal = modVal or ""
	
	for i=1,#self.Condition do
		if(self.Condition[i].Type == Type and self.Condition[i].Condition == Condition) then
			if(modVal ~= "") then
				self.Condition[i].Value = modVal
				if(gDBcedit == "1") then d(self.id .. " Changing Condition => ''" .. self.Condition[i].Value .. " " .. self.Condition[i].Condition .. " " .. self.Condition[i].Type .. "''") end
			end
			value = self.Condition[i].Value
			result = true
		end
		if(result) then break end
	end
	if(gDBcedit == "1" and not result) then d("Couldn't find condition: " .. Type .. " " .. Condition .. " for skill " .. self.name) end
	return value
end

function CraftingTool.Skill:Evaluate() -- true if all pass, false if one does not pass (Every condition added that is not in the standard roster needs to have a value leached from somewhere, check in this function)
	local result = true
	
	local condition1 = nil
	if(gDBcresults == "1") then
		local uid = tostring(self.uid)
		local i = uid:gsub(tostring(self.id),"")
		d("<<< Checking: "..self.name.." >>> " .. ((i == '' or i ==' ') and "0" or i))
	end
	for i=1,#self.Condition do
		local value = 0
		local condition = self.Condition[i]
		local ctype = string.lower(condition.Type)
		
		value = CraftingTool.currentSynth[ctype]
		
		if(ctype:match("description")) then value = CraftingTool.currentSynth.description end -- description check
		    
		if(ctype == "cp" or ctype == "enoughcp") then value = Player.cp.current end
		if(ctype == "buffid" or ctype == "notbuffid") then value = 1 end
		if(ctype == "iqstacks") then value = CraftingTool.IQStacks end
		--Default Checks--
		if(ctype == "level") then value = Player.level end
		
		result = condition:Evaluate(value) -- you pass in the value    
		
		if(not result) then break end
	end
	
	return result
end

function CraftingTool.Skill:Use() -- Uses a skill
	if(self.actionType == CraftingTool.cActionType["3"]) then
		self.WaitTime = 2000
	else
		self.WaitTime = 3000
	end
	
	ActionList:Cast(self.id,0)
end
--[[ End of Basic Skill Class ]]--

--[[ Condition Class ]]--
--Whatever you enter into new is basically: Value Cond Player.Value
--Example:
--New("cp", 100, "<=") would be checking if player cp is >= than 100 or if 100 <= than player cp
CraftingTool.Condition = {} -- cp, step, progress, quality, durability, description, buff 
function CraftingTool.Condition:New(Type, Value, Cond) -- you pass Type(i.e cp), Value(i.e 10), Cond(i.e '>=' or '=<' or '!=' or '==' also 'None'). If Type is Buff or Description then there is no need for Condition. It will just check
	Type = Type or "None"
	Value = Value or "None"
	Cond = Cond or "None"
	condition = { ["Type"] = Type,["Value"] = Value, ["Condition"] = Cond }
	setmetatable(condition, self)
	self.__index = self
	return condition
end
			
function CraftingTool.Condition:Evaluate(Value) -- pass in the value to test against (true if passes, false if not passes)
	local result = true
	
	if(Value == nil) then return true end --If value is "empty" then return true
	if(self.Value == nil or tonumber(self.Value) == 0 or self.Value == "" or self.Value == " " or self.Value == "None") then return true end --If value is "empty" then return true
	
	if(self.Type == "buffid") then --If buff exists OR If synth condition is... i.e good, excellent
		--d("Checking: " .. self.Type .. " " .. self.Value)
		result = PlayerHasBuff(tonumber(self.Value))
	elseif(self.Type == "notbuffid") then --If buff doesn't exists OR If synth condition is... i.e good, excellent
		--d("Checking: " .. self.Type .. " " .. self.Value)
		result = not PlayerHasBuff(tonumber(self.Value))
	elseif(self.Type:match("description")) then
		result = (self.Value == Value)
	else
		if(self.Condition == ">=") then
			result = ( tonumber(self.Value) >= tonumber(Value) )
		elseif(self.Condition == "<=") then
			result = ( tonumber(self.Value) <= tonumber(Value) )
		elseif(self.Condition == "!=") then
			result = not ( tonumber(self.Value) == tonumber(Value) )
		elseif(self.Condition == "==") then
			result = ( tonumber(self.Value) == tonumber(Value) )
		end
	end
	if(gDBcresults == "1") then
		d("Result is ".. tostring(result) .." for: " .. self.Type .. " as " .. self.Value .. " " .. self.Condition .. " " .. Value)
	end
	return result
end
--[[ End of Condition Class ]]--

--[[ Variables ]]--
CraftingTool.lastUse = 0 --Last time the skill was used + the time of the cast
CraftingTool.currentProf = "" --String representing current prof
CraftingTool.customDelay = 0
CraftingTool.openingSkill = false
CraftingTool.currentSynth = {} --Updates every tick
CraftingTool.EventsRegistered = {}
CraftingTool.SkillBook = {}
CraftingTool.lastQuality = 0
CraftingTool.CurrentlyOpenUID = 0
--[[ Profile Class ]]--
CraftingTool.Profile = {
	Name = "",
	Prof = "",
	Skills = CraftingTool.SkillList:New()
}

function CraftingTool.Profile:New()
	if(gSMnewProfileName and gSMnewProfileName ~= "" and gSMnewProfileName ~= "None") then
		gSMselectedProfile_listitems = gSMselectedProfile_listitems..","..gSMnewProfileName
		gSMselectedProfile = gSMnewProfileName
		self.Name = gSMselectedProfile
		self.Prof = gSBprof
		self.Skills = CraftingTool.SkillList:New()
		self:Update()
	end
end

function CraftingTool.Profile:Read(filename)
	filename = filename or ""
	d("Opening Crafting Tool Profile: "..filename)
	if ( filename and filename ~= "") then
		local profile = fileread(CraftingTool.profilepath..filename..".lua")
		if ( TableSize(profile) > 0) then
			self.Skills = CraftingTool.SkillList:New()
			self:Update()
			local prof = ""
			local skill = {}
			local conditionlist = ""
			local lastkey = ""
			for i,line in pairs(profile) do
				--d(line)
				local _, key, value = string.match(line, "(%w+)_(%w+)=(.*)")
				key = key:lower()
				if(key and value and key ~= "" and value ~= "") then
					if(key == "prof") then
						prof = value 
					elseif(key == "id") then
						local skilldetails = getSkillDetails(prof, key, tonumber(value))
						if(skilldetails) then
							skill = CraftingTool.Skill:New(skilldetails)
						end
						--d(skill)
					elseif(skill and key=="name" or key=="on" or key=="prio") then
						skill[key] = value
					elseif(skill and key == "end") then
						self.Skills:Add(skill)
						d("Skill loaded: ".. ((skill.name) and skill.name or "Couldn't read skill"))
						--d("Conditions: "..conditionlist)
						skill = {}
						skillname = ""
						conditionlist = ""
					elseif(skill) then
						local cCond = "None"
						if(string.match(key, "min")) then
							key = key:gsub("min", "")
							cCond = "<="
						elseif(string.match(key, "max")) then
							key = key:gsub("max", "")
							cCond = ">="
						elseif(string.match(key, "iqstacks")) then
							cCond = ">="
						elseif(string.match(key, "buff")) then
							key = key.."id"
						elseif(string.match(key, "condone")) then
							key = "description1"
						elseif(string.match(key, "condtwo")) then
							key = "description2"
						end
						--d(key .. " " .. value)
						if(conditionlist == "") then
							conditionlist = key.." '"..cCond.."'"
						elseif(key == lastkey) then
							conditionlist = conditionlist.." '"..cCond.."' )"
						else
							conditionlist = conditionlist..", "..key..((key:match("description") or key:match("buff")) and "" or "(").." '"..cCond.."'"
							lastkey = key
						end
						skill:AddCondition( CraftingTool.Condition:New(key, (key:match("description") and tostring(value) or tonumber(value)), cCond) )
					end
				end
			end	
			
			self.Name = filename
			self.Prof = prof
			
			--GUI call and sort
			if ( TableSize(self.Skills) > 0 ) then
				table.sort(self.Skills, function(a,b) return a.prio < b.prio end )	
				self:Update()
			end
			d("Crafting Tool Profile Successfully Opened")
		else
			d("Profile seems broken or empty")
		end
	end
	GUI_UnFoldGroup(CraftingTool.smanager.name, "Skill List")
	GUI_WindowVisible(CraftingTool.sview.name,false)
end

function CraftingTool.Profile:Write(filename)
	filename = filename or ""
	local filepath = "" --CraftingTool.profilepath..filename..".lua"
	
	if ((filename ~= nil and filename ~= "None" and filename ~= "" and filename ~= " ")) then
		filepath = CraftingTool.profilepath..filename..".lua"
	end
	
	if(filepath ~= "") then
		d("Saving the crafting profile into: "..filename)
		d("Full path: "..filepath)
		local writeStr = "CT_Prof="..gSBprof.."\n"
		for i, skill in pairs(self.Skills) do
			--d(skill)
			writeStr = writeStr.."CT_ID="..skill.id.."\n"
			writeStr = writeStr.."CT_NAME="..skill.name.."\n"
			
			writeStr = writeStr.."CT_ON="..skill.on.."\n"
			writeStr = writeStr.."CT_PRIO="..skill.prio.."\n"
			writeStr = writeStr.."CT_IQSTACKS="..skill:FindCondition( "iqstacks", ">=").."\n"
			
			writeStr = writeStr.."CT_CPMIN="..skill:FindCondition( "cp", "<=").."\n"
			writeStr = writeStr.."CT_CPMAX="..skill:FindCondition( "cp", ">=").."\n"
			writeStr = writeStr.."CT_STEPMIN="..skill:FindCondition( "step", "<=").."\n"
			writeStr = writeStr.."CT_STEPMAX="..skill:FindCondition( "step", ">=").."\n"
			writeStr = writeStr.."CT_PROGRESSMIN="..skill:FindCondition( "progress", "<=").."\n"
			writeStr = writeStr.."CT_PROGRESSMAX="..skill:FindCondition( "progress", ">=").."\n"
			writeStr = writeStr.."CT_QUALITYMIN="..skill:FindCondition( "quality", "<=").."\n"
			writeStr = writeStr.."CT_QUALITYMAX="..skill:FindCondition( "quality", ">=").."\n"
			writeStr = writeStr.."CT_DURABILITYMIN="..skill:FindCondition( "durability", "<=").."\n"
			writeStr = writeStr.."CT_DURABILITYMAX="..skill:FindCondition( "durability", ">=").."\n"
			
			writeStr = writeStr.."CT_CONDONE="..((skill:FindCondition( "description1", "None")) and skill:FindCondition( "description1", "None") or "None").."\n"
			writeStr = writeStr.."CT_CONDTWO="..((skill:FindCondition( "description2", "None")) and skill:FindCondition( "description2", "None") or "None").."\n"
			writeStr = writeStr.."CT_BUFF="..skill:FindCondition( "buffid", "None").."\n"
			writeStr = writeStr.."CT_NOTBUFF="..skill:FindCondition( "notbuffid", "None").."\n"
			
			writeStr = writeStr.."CT_END=0\n"
		end
		d(tostring(filewrite(filepath,writeStr)))
	else
		d("Incorrect profile name: " .. filename)
	end
end

function CraftingTool.Profile:Update()
	GUI_DeleteGroup(CraftingTool.smanager.name, "Skill List")
	table.sort(self.Skills, function(a,b) return tonumber(a.prio) < tonumber(b.prio) end )	
	local y = 1
	for i = 1,#self.Skills do					
		if (self.Skills[i] ~= nil ) then
			--d(Skills[i].id .. " " .. Skills[i].name)
			CraftingTool.AddSkillManagerEntry(self.Skills[i], y)
			y = y + 1
		end
	end
	GUI_UnFoldGroup(CraftingTool.smanager.name, "Skill List")
end

function CraftingTool.Profile:IsUniqueSkill( uid ) -- return whether the skill with this uid is going to be unique within the profile (boolean)
	local unique = true
	
	for i,e in pairs(self.Skills) do
		if(e.uid == tonumber(uid)) then
			unique = false
			--d(e.uid)
			break
		end
	end
	
	return unique
end

function CraftingTool.Profile:UpdateProfileList()
	local profiles = "None"	
	local profilelist = dirlist(CraftingTool.profilepath,".*lua")
	if ( TableSize(profilelist) > 0) then	
		for i, profile in pairs(profilelist) do			
			profile = string.gsub(profile, ".lua", "")
			profiles = profiles..","..profile
		end		
	else
		d("No profiles found")
	end
	gSMselectedProfile_listitems = profiles
	gSMselectedProfile = "None"
end
--[[ End of Profile Class ]]--

--Pulse from game loop
function CraftingTool.Update(Event, ticks)  -- MAIN LOOP
	if( gSMactive == "1" ) then
		CraftingTool.currentSynth = Crafting:SynthInfo()
		CraftingTool.customDelay = tonumber(gMWcdelay)
		gMWcraftsleft = CraftingTool.craftsLeft
		
		if((ticks - CraftingTool.lastUse >= CraftingTool.customDelay) and CraftingTool.Profile.Prof ~= "" and CraftingTool.cProf[CraftingTool.Profile.Prof].id == Player.job) then
			local keepCrafting = (CraftingTool.doNonStopCraft or CraftingTool.doLimitedCraft)
			
			if(CraftingTool.currentSynth) then -- Synth logic
					gMWcrafting = "true"
					gMWitemid = CraftingTool.currentSynth.itemid
					
					if(CraftingTool.lastQuality ~= CraftingTool.currentSynth.quality and PlayerHasBuff(CraftingTool.IQBuffID)) then CraftingTool.IQStacks = CraftingTool.IQStacks + 1 end
									
					local skill_list = CraftingTool.Profile.Skills
					local casted = false
					
					for i=1,TableSize(skill_list) do --Loop through all the skills and select a skill which has the lowest(best) priorty and meets all the criteria
						local skill = skill_list[i]
						--d("Skill: " .. skill.name)
						local use = skill:Evaluate()
						if(use and tonumber(skill.on) == 1) then
							casted = true
							skill:Use()
							gMWlastskill = skill:Get("name")
							d("< Casted: " .. gMWlastskill .. " >")
							CraftingTool.lastUse = ticks + skill.WaitTime
							break
						end
					end
					
					gMWiqstacks = CraftingTool.IQStacks
					
					if(casted) then
						CraftingTool.lastQuality = CraftingTool.currentSynth.quality 
					else
						d("Can't cast anything please check that your profile is set up correctly")
					end
			elseif(keepCrafting) then
				if (not Crafting:IsCraftingLogOpen()) then
					Crafting:ToggleCraftingLog()
				else
					gMWcrafting = "false"
					gMWitemid = 0
					gMWiqstacks = 0
					CraftingTool.IQStacks = 0
					CraftingTool.lastQuality = 0
					gMWlastskill = "None"
					--gMWnq = "0"
					--gMWqh = "0"
					d("<< Crafting Item >>")
					Crafting:CraftSelectedItem()
					Crafting:ToggleCraftingLog()
					CraftingTool.lastUse = ticks + 4500
					if(CraftingTool.doLimitedCraft and CraftingTool.craftsLeft <= 1) then
						CraftingTool.doLimitedCraft = false
						CraftingTool.craftsLeft = 0
					elseif(CraftingTool.doNonStopCraft) then
						gMWcraftsleft = 0
					else
						CraftingTool.craftsLeft = CraftingTool.craftsLeft - 1
					end
				end
			end
		end
	end
end

--[[ GUI Update ]]--
function CraftingTool.GUIVARUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if(k == "gSBprof" or k == "gSBshowCC") then 
			updateSkillBook()
		elseif(k == "gSMselectedProfile") then
			Settings.CraftingTool.gSMselectedProfile = gSMselectedProfile
			CraftingTool.Profile:Read(gSMselectedProfile)
		elseif(string.match(k, "gSV")) then 
			updateSkillFromView(k,v)
		elseif(k:match("gMW")) then
			Settings.CraftingTool[tostring(k)] = v
		end
	end
end

--[[ Module and Window Init ]]--
function CraftingTool.ModuleInit()
	--Init windows
	GUI_NewWindow(CraftingTool.mainwindow.name, CraftingTool.mainwindow.x, CraftingTool.mainwindow.y, CraftingTool.mainwindow.w, CraftingTool.mainwindow.h)
	MainWindow()
	GUI_SizeWindow(CraftingTool.mainwindow.name,CraftingTool.mainwindow.w,CraftingTool.mainwindow.h)
	
	GUI_NewWindow(CraftingTool.sbook.name,CraftingTool.sbook.x,CraftingTool.sbook.y,CraftingTool.sbook.width,CraftingTool.sbook.height)
	SkillBook()
	GUI_SizeWindow(CraftingTool.sbook.name, CraftingTool.sbook.w, CraftingTool.sbook.h)
	GUI_WindowVisible(CraftingTool.sbook.name,false)	
	
	GUI_NewWindow(CraftingTool.smanager.name,CraftingTool.smanager.x,CraftingTool.smanager.y,CraftingTool.smanager.width,CraftingTool.smanager.height)
	SkillMngr()
	GUI_SizeWindow(CraftingTool.smanager.name, CraftingTool.smanager.w, CraftingTool.smanager.h)
	GUI_WindowVisible(CraftingTool.smanager.name,false)	
	
	GUI_NewWindow(CraftingTool.sview.name,CraftingTool.sview.x,CraftingTool.sview.y,CraftingTool.sview.width,CraftingTool.sview.height)
	SkillView()
	GUI_SizeWindow(CraftingTool.sview.name, CraftingTool.sview.w, CraftingTool.sview.h)
	GUI_WindowVisible(CraftingTool.sview.name,false)
end

--Initialises CraftingTool Window
function MainWindow()
	--debug window
	GUI_NewCheckbox(CraftingTool.mainwindow.name, "Add Cond", "gDBcadd", "Debug")
	GUI_NewCheckbox(CraftingTool.mainwindow.name, "Edit Cond", "gDBcedit", "Debug")
	GUI_NewCheckbox(CraftingTool.mainwindow.name, "Evaluate Cond", "gDBcresults", "Debug")
	gDBcadd = "0"
	gDBcedit = "0"
	gDBcresults = "0"
	
	--Info Window 
	GUI_NewField(CraftingTool.mainwindow.name,"Crafting","gMWcrafting", "Info")
	GUI_NewNumeric(CraftingTool.mainwindow.name,"Crafts Left","gMWcraftsleft", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"","gMWempty", "Info")
	GUI_NewNumeric(CraftingTool.mainwindow.name,"Item ID","gMWitemid", "Info")
	GUI_NewNumeric(CraftingTool.mainwindow.name,"IQ Stacks","gMWiqstacks", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"Last Skill","gMWlastskill", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"","gMWempty", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"NQ Crafted","gMWnq", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"HQ Crafted","gMWqh", "Info")
	gMWnq = "Unavailable"
	gMWqh = "Unavailable"
	gMWcraftsleft = 0
	--
	
	--Settings gMWcdelay
	GUI_NewCheckbox(CraftingTool.mainwindow.name, "Skill Manager", "gSMactive", "Settings")
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Custom Delay", "gMWcdelay", "Settings")
		
	if (Settings.CraftingTool.gSMactive == nil) then
		Settings.CraftingTool.gSMactive = "1"
	end
	gSMactive = Settings.CraftingTool.gSMactive
	
	if (Settings.CraftingTool.gMWcdelay == nil) then
		Settings.CraftingTool.gMWcdelay = "500"
	end
	gMWcdelay = Settings.CraftingTool.gMWcdelay
	
	--[[GUI_NewField(CraftingTool.mainwindow.name, "", "gMWEmpty", "Settings")
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Craftsmanship", "gMWCraftsmanship", "Settings")	
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Control", "gMWControl", "Settings")
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Recipe Level", "gMWRecipeLevel", "Settings")
	
	if (Settings.CraftingTool.gMWCraftsmanship == nil) then
		Settings.CraftingTool.gMWCraftsmanship = "1"
	end
	gMWCraftsmanship = Settings.CraftingTool.gMWCraftsmanship
	if (Settings.CraftingTool.gMWControl == nil) then
		Settings.CraftingTool.gMWControl = "1"
	end
	gMWControl = Settings.CraftingTool.gMWControl
	if (Settings.CraftingTool.gMWRecipeLevel == nil) then
		Settings.CraftingTool.gMWRecipeLevel = "1"
	end
	gMWRecipeLevel = Settings.CraftingTool.gMWRecipeLevel
	]]--
	
	GUI_UnFoldGroup(CraftingTool.mainwindow.name,"Settings")
	--
	
	--Craft Window
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Craft Amount", "gMWCraftFor", "Craft")
	GUI_NewComboBox(CraftingTool.mainwindow.name,"How To Craft","gMWHowToCraft", "Craft", "Until Stopped,Single,Limited")
	gMWHowToCraft = "Until Stopped"
	GUI_NewButton(CraftingTool.mainwindow.name, "Start", "StartCraft","Craft") 
	GUI_NewButton(CraftingTool.mainwindow.name, "Stop", "StopCraft","Craft") 
	--
	
	--Buttons at the bottom
	GUI_NewButton(CraftingTool.mainwindow.name, "Skill Manager", "OpenSkillMngr") 
	--
	
	RegisterEventHandler("StartCraft", CraftingTool.Craft)
	RegisterEventHandler("StopCraft", CraftingTool.Craft)
	RegisterEventHandler("OpenSkillMngr", CraftingTool.SkillMngr)
end

--Initialises SkillBook
function SkillBook()
	GUI_NewComboBox(CraftingTool.sbook.name,"Profession","gSBprof", "Settings", " ")
	
	gSBprof_listitems = " "
	for i,e in pairs(CraftingTool.cProf) do
		gSBprof_listitems = gSBprof_listitems..","..i
	end
	gSBprof = "Weaver"
	
	GUI_NewCheckbox(CraftingTool.sbook.name, "Show Cross Class", "gSBshowCC", "Settings")
	gSBshowCC = "1"
	
	GUI_UnFoldGroup(CraftingTool.sbook.name,"Settings")
	
	updateSkillBook()
end

--Initialises SkillMngr Window
function SkillMngr()
	--Skill manager settings
	GUI_NewComboBox(CraftingTool.smanager.name, "Profile","gSMselectedProfile", "Settings", " ")
	
	 CraftingTool.Profile:UpdateProfileList()

	if (Settings.CraftingTool.gSMselectedProfile == nil) then
		Settings.CraftingTool.gSMselectedProfile = " "
	end
	gSMselectedProfile = Settings.CraftingTool.gSMselectedProfile
	
	GUI_UnFoldGroup(CraftingTool.smanager.name,"Settings")
	--Skill manager Editor
	GUI_NewField(CraftingTool.smanager.name, "Profile Name", "gSMnewProfileName", "Editor")
	GUI_NewButton(CraftingTool.smanager.name, "Create New", "Create New", "Editor")
	GUI_NewButton(CraftingTool.smanager.name, "Skill Book", "Skill Book")
	
	GUI_UnFoldGroup(CraftingTool.smanager.name,"Skill List") -- List of skills as a button
	
	GUI_NewButton(CraftingTool.smanager.name, "Save Profile", "Save Profile")
	RegisterEventHandler("Create New", CraftingTool.SkillManagerHandler)
	RegisterEventHandler("Skill Book", CraftingTool.SkillManagerHandler)
	RegisterEventHandler("Save Profile", CraftingTool.SkillManagerHandler)
	CraftingTool.Profile:Read(gSMselectedProfile)
end

--Initialises SkillView Window
function SkillView()
	--List of Keys: name, on, prio, cp, step, progress, quality, durability, description, buffid .. Min,Max 
	GUI_NewField(CraftingTool.sview.name, "Id", "gSVid", "Skill")
	GUI_NewField(CraftingTool.sview.name, "Name", "gSVname", "Skill")
	GUI_NewField(CraftingTool.sview.name, "", "empty", "Skill")
	GUI_NewCheckbox(CraftingTool.sview.name, "On", "gSVon", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name, "Priority", "gSVprio", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"IQStacks >=","gSViqstacks", "Skill")
	local s = "------------------------------------------------------------------------------------------------------"
	GUI_NewField(CraftingTool.sview.name, s, "emptyS", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"CP >=","gSVcpMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"CP <=","gSVcpMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"STEP >=","gSVstepMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"STEP <=","gSVstepMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"PROGRESS >=","gSVprogressMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"PROGRESS <=","gSVprogressMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"QUALITY >=","gSVqualityMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"QUALITY <=","gSVqualityMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"DURABILITY >=","gSVdurabilityMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"DURABILITY <=","gSVdurabilityMax", "Skill")--
	GUI_NewField(CraftingTool.sview.name, s, "emptyS", "Skill")
	GUI_NewComboBox(CraftingTool.sview.name, "CONDITION =","gSVcondition1", "Skill", "None,Poor,Normal,Good,Excellent")
	GUI_NewComboBox(CraftingTool.sview.name, "OR","gSVcondition2", "Skill", "None,Poor,Normal,Good,Excellent")
	GUI_NewField(CraftingTool.sview.name, s, "emptyS", "Skill")
	emptyS = s
	GUI_NewNumeric(CraftingTool.sview.name,"Buff =","gSVbuffid", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"Buff not =","gSVnotbuffid", "Skill")
	
	GUI_UnFoldGroup(CraftingTool.sview.name,"Skill") -- Skill
	
	GUI_NewButton(CraftingTool.sview.name, "DELETE", "DELETE")
	--GUI_NewButton(CraftingTool.sview.name, "Priority DOWN", "DOWN")
	--GUI_NewButton(CraftingTool.sview.name, "Priority UP", "UP")
	--RegisterEventHandler("UP", CraftingTool.SkillViewHandler)
	--RegisterEventHandler("DOWN", CraftingTool.SkillViewHandler)
	RegisterEventHandler("DELETE", CraftingTool.SkillViewHandler)
end

--[[ Skill Book Functions ]]--
function updateSkillBook()
	CraftingTool.Profile.Prof = gSBprof
	local Skills = getSkills(gSBprof)
	local CrossClass = getSkills("CrossClass")
	
	for i,e in pairs(CraftingTool.cActionType) do
		GUI_DeleteGroup(CraftingTool.sbook.name,e.." List")
	end
	GUI_DeleteGroup(CraftingTool.sbook.name, "Cross Class")
	
	if(Skills) then
		for i=1,#Skills do
			Skills[i]["CC"] = false
			addSkillBookEntry(Skills[i])
		end
	end
	
	if(CrossClass and gSBshowCC == "1") then
		for prof,skilllist in pairs(CrossClass) do
			if(prof ~= gSBprof and skilllist) then
				local sprof = "gCC"..prof
				GUI_NewField(CraftingTool.sbook.name, prof, sprof, "Cross Class")
				_G[sprof] = "Skills"
				for i=1,#skilllist do
					skilllist[i]["CC"] = true
					addSkillBookEntry(skilllist[i], "Cross Class")
				end
			end
		end
	end
end
function addSkillBookEntry ( skill, groupName )
	if (skill) then
		local sname = skill.name
		groupName = groupName or skill.actionType.." List"
		
		GUI_NewButton(CraftingTool.sbook.name, sname, sname, groupName)
		
		if ( CraftingTool.EventsRegistered[sname] == nil ) then
			RegisterEventHandler( sname, CraftingTool.AddSkillToProfile)
			CraftingTool.EventsRegistered[sname] = 1
		end	
		
		CraftingTool.SkillBook[sname] = skill
	end
end

function CraftingTool.AddSkillToProfile( sname )
	local skilldetails = getSkillDetails(gSBprof, "id", tonumber(CraftingTool.SkillBook[sname].id))
	d("Adding skill: "..sname)
	local skill = CraftingTool.Skill:New(skilldetails)
	--d(skill)
	if (skill ~= nil or skill == {}) then
		if(CraftingTool.Profile.Name and CraftingTool.Profile.Name ~= "" and CraftingTool.Profile.Name ~= "None") then
			skill["on"] = "1"
			skill.prio = TableSize(CraftingTool.Profile.Skills) + 1
			value = 0
			for e,i in pairs({ "iqstacks", "cp", "step", "progress", "quality", "durability", "description1", "description2", "buffid", "notbuffid" }) do
				if(i:match("description")) then
					if(skill:FindCondition(i, "None") == nil) then skill:AddCondition(CraftingTool.Condition:New(i, " ")) end
				elseif(i == "buffid" or i == "notbuffid") then
					if(skill:FindCondition(i, "None") == nil) then skill:AddCondition(CraftingTool.Condition:New(i, value)) end
				elseif(i == "iqstacks") then
					if(skill:FindCondition(i, ">=") == nil) then skill:AddCondition(CraftingTool.Condition:New(i, tonumber(value), ">=")) end
				else
					if(skill:FindCondition(i, ">=") == nil) then skill:AddCondition(CraftingTool.Condition:New(i, tonumber(value), ">=")) end
					if(skill:FindCondition(i, "<=") == nil) then skill:AddCondition(CraftingTool.Condition:New(i, tonumber(value), "<=")) end
				end
			end
			CraftingTool.Profile.Skills:Add(skill)
			CraftingTool.AddSkillManagerEntry(skill)
		end
	else
		d("Skill seems to be empty or loaded incorrectly")
	end
end

--[[ Skill Manager Functions ]]--
function CraftingTool.AddSkillManagerEntry(skill, y)
	if (skill) then
		local uid = skill.uid
		local bname = "["..tostring(y or skill.prio).."] "..skill.name .. " [" .. ((skill.on == "1") and "+" or "-") .. "]"
		
		GUI_NewButton(CraftingTool.smanager.name, bname, uid, "Skill List")
		RegisterEventHandler( uid, CraftingTool.SkillView )
	end
end

--[[ Skill View Functions ]]--
function updateSkillFromView( varname, value ) -- Updates the skill inside the Profile. Not the file.
	--d("List Position: "..id.." Skill ID: "..gSVid .. " VarName: " .. varname)
	local skill = CraftingTool.Profile.Skills:getSkillByUID(tonumber(CraftingTool.CurrentlyOpenUID))
	if(skill ~= 0) then
		local key = string.match(varname, "gSV(%w+)")
		key = key:lower():gsub("condition", "description")
		local ctype = "None"
			
		if(string.match(key, 'min') or string.match(key, 'max')) then
			ctype = (string.match(key, 'min') and "<=" or ">=")
			key = key:gsub('min', ''):gsub('max', '')
		end
		if(key == "iqstacks") then ctype = ">=" end
				
		if(key == "id" or key=="name" or key=="on" or key=="prio") then
			skill[key] = value
			if(not CraftingTool.openingSkill) then CraftingTool.Profile:Update() end
		elseif(key:match("description")) then
			skill:FindCondition(key, ctype, tostring(value))
		else
			skill:FindCondition(key, ctype, tonumber(value))
		end
	end
end
function CraftingTool.UpdateView ( skill, opening )
	CraftingTool.openingSkill = opening or false
	if (skill and skill ~= {} and skill.id and skill.name) then
		local id 			= skill.id
		local name 			= skill.name
		local on 			= skill.on or 1
		local prio 			= skill.prio or 1
		local iqstacks		= skill:FindCondition( "iqstacks", ">=" ) or 0
		local cpMin		 	= skill:FindCondition( "cp", "<=" ) or 0
		local cpMax		 	= skill:FindCondition( "cp", ">=" ) or 0
		local stepMin		= skill:FindCondition( "step", "<=" ) or 0
		local stepMax		= skill:FindCondition( "step", ">=" ) or 0
		local progressMin	= skill:FindCondition( "progress", "<=" ) or 0
		local progressMax	= skill:FindCondition( "progress", ">=" ) or 0
		local qualityMin	= skill:FindCondition( "quality", "<=" ) or 0
		local qualityMax	= skill:FindCondition( "quality", ">=" ) or 0
		local durabilityMin = skill:FindCondition( "durability", "<=" ) or 0
		local durabilityMax = skill:FindCondition( "durability", ">=" ) or 0
		local description1	= skill:FindCondition( "description1", "None" ) or "None"
		local description2	= skill:FindCondition( "description2", "None" ) or "None"
		local buffid		= skill:FindCondition( "buffid", "None" ) or 0
		local notbuffid		= skill:FindCondition( "notbuffid", "None" ) or 0
		
		gSVid 			 = id
		gSVname 		 = name
		gSVon			 = on
		gSVprio			 = prio
		gSViqstacks		 = iqstacks
		gSVcpMin		 = cpMin
		gSVcpMax		 = cpMax
		gSVstepMin		 = stepMin
		gSVstepMax		 = stepMax
		gSVprogressMin	 = progressMin
		gSVprogressMax	 = progressMax
		gSVqualityMin	 = qualityMin
		gSVqualityMax	 = qualityMax
		gSVdurabilityMin = durabilityMin
		gSVdurabilityMax = durabilityMax
		gSVcondition1	 = description1
		gSVcondition2	 = description2
		gSVbuffid		 = buffid
		gSVnotbuffid	 = notbuffid
		
		local window = GUI_GetWindowInfo(CraftingTool.smanager.name)	
		GUI_MoveWindow(CraftingTool.sview.name, window.x+window.width,window.y) 
		GUI_WindowVisible(CraftingTool.sview.name,true)
	end
end

--[[ Button Handlers ]]--
function CraftingTool.Craft( dir )
	if(dir == "StartCraft") then
		CraftingTool.doNonStopCraft = false
		CraftingTool.doLimitedCraft = false
		
		if(gMWHowToCraft == "Non Stop") then
			CraftingTool.doNonStopCraft = true
		elseif(gMWHowToCraft == "Single") then
			CraftingTool.craftsLeft = 1
			CraftingTool.doLimitedCraft = true
		elseif(gMWHowToCraft == "Limited") then
			CraftingTool.craftsLeft = tonumber(gMWCraftFor)
			CraftingTool.doLimitedCraft = true
		end
	elseif(dir == "StopCraft") then
		CraftingTool.doNonStopCraft = false
		CraftingTool.doLimitedCraft = false
		CraftingTool.craftsLeft = 0
	end
end

function CraftingTool.SkillMngr( dir )
	local window = GUI_GetWindowInfo(CraftingTool.mainwindow.name)	
	GUI_MoveWindow(CraftingTool.smanager.name, window.x+window.width,window.y) 
	GUI_WindowVisible(CraftingTool.smanager.name,true)
end

function CraftingTool.SkillView( uid )
	CraftingTool.CurrentlyOpenUID = tonumber(uid)
	--d(uid.." "..tostring(CraftingTool.CurrentlyOpenUID))
	local skill = CraftingTool.Profile.Skills:getSkillByUID(uid)
	local level = skill:FindCondition("level","<=") or "CC"
	CraftingTool.UpdateView(skill, opening)
end

function CraftingTool.SkillManagerHandler( dir )
	if(dir == "Create New") then
		CraftingTool.Profile:New()
	elseif(dir == "Skill Book") then
		local window = GUI_GetWindowInfo(CraftingTool.smanager.name)	
		GUI_MoveWindow(CraftingTool.sbook.name, window.x+window.width,window.y)
		GUI_WindowVisible(CraftingTool.sbook.name,true)
	elseif(dir == "Save Profile") then
		CraftingTool.Profile:Write(gSMselectedProfile)
	end
end

function CraftingTool.SkillViewHandler( dir )
	if(dir == "DELETE") then
		if ( TableSize(CraftingTool.Profile.Skills) > 0 ) then
			local uid = tonumber(CraftingTool.CurrentlyOpenUID)
			CraftingTool.Profile.Skills:Remove(CraftingTool.Profile.Skills:getSkillByUID(uid))
			CraftingTool.Profile:Update()
			GUI_WindowVisible(CraftingTool.sview.name,false)
		end
	end
end

--[[  Helper Functions  ]]--
function getProf(id) -- Gets the profession name from profession id
	local localLookUp = {
	["8"] = "Carpenter",
	["9"] = "Blacksmith",
	["10"] = "Armourer",
	["11"] = "Goldsmith",
	["12"] = "Leatherworker",
	["13"] = "Weaver",
	["14"] = "Alchemist",
	["15"] = "Culinary",
	["16"] = "SkillMngr" }
	return localLookUp[tostring(id)]
end

function PlayerHasBuff(id) -- Returns a buffid of the buff needing to be recast
	local hasBuff = false
	if (Player) then
		local pbuffs = Player.buffs
		if (pbuffs) then
			for i,buff in pairs(pbuffs) do
				if (buff) then
					if (buff.id == id) then
						hasBuff = true
						break
					end
				end
			end
		end
	end
	return hasBuff
end

-- formula based on http://www.bluegartr.com/threads/117684-The-crafting-thread.?p=5890541&viewfull=1#post5890541
function ProgressPrediction(level, ship) -- needs testing for large differences ( > 15 && < -5)
	local diff = Player.level - level
	local corr = 1.55 -- cap is about 55%
	
	if ( diff <= 0 ) then -- this may not be correct for * and ** items
		corr = 1 + (0.10 * diff)
	elseif ( diff > 0 and diff <= 5 ) then
		corr = 1 + (0.05 * diff)
	elseif ( diff > 5 and diff <= 15 ) then
		corr = 1 + (0.022 * diff) + 0.15
	elseif ( diff > 15 and diff <= 25 ) then
		corr = 1 + (0.007 * diff) + 0.375 -- assuming linear, won't matter much because mostly 1-hit completions
	end
	
	return corr * ((0.21 * ship) + 1.6)
end

-- formula based on http://www.bluegartr.com/threads/117684-The-crafting-thread.
function QualityPrediction(level, cont)
	local diff = Player.level - level
	local corr = 1 -- no bonus for synths under your level
	
	if ( diff < 0 ) then -- is this appropriate for ** items?
		corr = 1 + (0.05 * diff)
	end
	
	return corr * ((0.36 * cont) + 34)
end

--[[ Register Functions ]]--
RegisterEventHandler("Gameloop.Update", CraftingTool.Update) -- the normal pulse from the gameloop
RegisterEventHandler("Module.Initalize", CraftingTool.ModuleInit)
RegisterEventHandler("GUI.Update", CraftingTool.GUIVARUpdate)