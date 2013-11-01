--What is not done:
--1. Item Detection (for amount of NQ and HQ items)
--2. IQStacks
--3. End craft prediction 
--4. Cross-Class skills(require a tiny bit of code to be shown in SkillBook) + a bit into read\write (add another variable CC) :)

--Notes:
--For conditions, in SkillView it shows >= but the equivalent code wise in condition is <=

--[[ Create a new table ]]--
CraftingTool={ }

CraftingTool.profilepath = GetStartupPath() .. [[\LuaMods\CraftingTool\Profiles\]];
--[[ Window Settings ]]--
CraftingTool.mainwindow = { name = "CraftingTool", x = 500, y = 200, w = 250, h = 350 }
CraftingTool.smanager = { name = "CraftingTool_SkillManager", x = CraftingTool.mainwindow.x + CraftingTool.mainwindow.w, y = 200, w = 250, h = 350 }
CraftingTool.sbook = { name = "CraftingTool_SkillBook", x = CraftingTool.smanager.x + CraftingTool.smanager.w, y = 200, w = 250, h = 350 }
CraftingTool.sview = { name = "CraftingTool_SkillView", x = CraftingTool.sbook.x + CraftingTool.sbook.w, y = 200, w = 250, h = 500 }

--[[ Crafting States ]]--
CraftingTool.doNonStopCraft = false --Used for non-stop craft
CraftingTool.doLimitedCraft = false --Used for a limited craft
CraftingTool.craftsLeft = 0

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

--[[ SkillList Class]]--
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
	local id = value.id
	for i,e in pairs(self) do
		if(e.id == id) then
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

function CraftingTool.SkillList:getSkillById( skillID )
	local skill = nil
	
	for i,e in pairs(self) do
		if(e.id == tonumber(skillID)) then
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

--[[ Basic Skill Class ]]--
CraftingTool.Skill = { -- Can have many params like  ["id"] = 0, ["name"] = "", ["level"] = "", ["cost"] = "", ["actionType"] = "", ["buffid"] = "", ["length"] = "", ["efficiency"] = "", ["chance"] = ""
	WaitTime=3000,
	Condition = {},
	on = 0
}

function CraftingTool.Skill:New( skilldetails, conditionlist, CC ) -- Creates a new variable of class CraftingTool.Skill requires skill details leached from Prof.lua files and a boolean stating whether its cross class or not(default false)
	CC = CC or false
		
	conditionlist = ((type(conditionlist) == 'table') and conditionlist or {})

	skilldetails = skilldetails or { }
	setmetatable(skilldetails, self)
	
	self.__index = self
	
	if(self.id) then
		skilldetails["Condition"][self.id] = conditionlist
	end
	
	skilldetails:AddDefConditions(CC)
	
	return skilldetails
end

function CraftingTool.Skill:Destructor()
	self.Condition[self.id] = nil
end

function CraftingTool.Skill:AddDefConditions(CC) -- Adds default conditions
	if(not CC) then -- If not Cross class then add a level Condition
		self:AddCondition(CraftingTool.Condition:New("level", self.level, "<="))
	end
	if(self.buffid) then --If a buff then add a default notbuff condition
		self:AddCondition(CraftingTool.Condition:New("notbuff", self.buffid, "None"))
	end
	self:AddCondition(CraftingTool.Condition:New("enoughcp", self.cost, "<="))
end
 
function CraftingTool.Skill:Get( varname ) -- e.g somevar:Get("id") will return the id of this skill
	return self[string.lower(varname)]
end

function CraftingTool.Skill:AddCondition( condition ) --adds a condition to the condition list
	if(self.Condition[self.id] == nil) then
		self.Condition[self.id] = {}
	end
	
	if(self:FindCondition(condition.Type, condition.Condition)) then
		d("Condition already exists, augmenting it's value")
		self:FindCondition(condition.Type, condition.Condition, condition.Value)
	else
		--d(("Skill ID: %7d"):format((self.id or 0)) .. " TSize: " .. #self.Condition[self.id] + 1 .. " => " .. ("New condition: ^%s %s %s^"):format(condition.Value, condition.Condition, condition.Type))
		table.insert(self.Condition[self.id], #self.Condition[self.id] + 1, condition)
	end
end

function CraftingTool.Skill:FindCondition( Type, Condition, modVal ) -- If you pass modVal then it will modify the value of this condition to modVal and return it to you, otherwise will just return the value of the cond
	local value = nil
	local result = false
	modVal = modVal or ""
	
	for i=1,#self.Condition[self.id] do
		if(self.Condition[self.id][i].Type == Type and self.Condition[self.id][i].Condition == Condition) then
			if(modVal ~= "") then
				self.Condition[self.id][i].Value = modVal
				d(self.id .. " Changing Condition => ''" .. self.Condition[self.id][i].Value .. " " .. self.Condition[self.id][i].Condition .. " " .. self.Condition[self.id][i].Type .. "''")
			end
			value = self.Condition[self.id][i].Value
			result = true
		end
		if(result) then break end
	end
	
	return value
end

function CraftingTool.Skill:Evaluate() -- true if all pass, false if one does not pass (Every condition added that is not in the standard roster needs to have a value leached from somewhere, check in this function)
	local result = true
	
	for i=1,#self.Condition[self.id] do
		local value = 0
		local condition = self.Condition[self.id][i]
		--User Entered--
		
		local var = CraftingTool.currentSynth[string.lower(condition.Type)] 
		if(var) then value = var end -- description check
		
		if(string.lower(condition.Type) == "cp") then value = Player.cp.current end
		if(string.lower(condition.Type) == "buff" or string.lower(condition.Type) == "notbuff") then value = 1 end
		if(string.lower(condition.Type) == "iqstacks") then value = CraftingTool.IQStacks end
		--Default Checks--
		if(string.lower(condition.Type) == "level") then value = Player.level end
		if(string.lower(condition.Type) == "enoughcp") then value = Player.cp.current end
		
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
	
	if(self.actionType == CraftingTool.cActionType["1"] and PlayerHasBuff(CraftingTool.IQBuffID)) then CraftingTool.IQStacks = CraftingTool.IQStacks + 1 end
	
	ActionList:Cast(self.id,0)
end

--[[ Condition Class ]]--
--Whatever you enter into new is basically: Value Cond Player.Value
--Example:
--New("cp", 100, ">=") would be checking if player cp is >= than 100
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
	
	if(self.Type == "buff") then --If buff exists OR If synth condition is... i.e good, excellent
		d("Checking: " .. self.Type .. " " .. self.Value)
		result = PlayerHasBuff(tonumber(self.Value))
	elseif(self.Type == "notbuff") then --If buff doesn't exists OR If synth condition is... i.e good, excellent
		d("Checking: " .. self.Type .. " " .. self.Value)
		result = not PlayerHasBuff(tonumber(self.Value))
	elseif(self.Type == "description") then
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
	--if(not result) then d("Result is false for: " .. self.Type .. " as " .. self.Value .. self.Condition .. Value) end
	return result
end

--[[ Variables ]]--
CraftingTool.StartedCrafting = false
CraftingTool.lastUse = 0 --Last time the skill was used + the time of the cast
CraftingTool.currentProf = "" --String representing current prof
CraftingTool.customDelay = 0
CraftingTool.currentSynth = {} --Updates every tick
CraftingTool.EventsRegistered = {}
CraftingTool.SkillBook = {}
CraftingTool.Profile = {
	Name = "",
	Prof = "",
	Skills = CraftingTool.SkillList:New()
}

--Pulse from game loop
function CraftingTool.Update(Event, ticks)  -- MAIN LOOP
	CraftingTool.currentSynth = Crafting:SynthInfo()
	CraftingTool.customDelay = tonumber(gMWcdelay)
	
	if(ticks - CraftingTool.lastUse >= CraftingTool.customDelay and CraftingTool.Profile.Prof ~= "" and CraftingTool.cProf[CraftingTool.Profile.Prof].id == Player.job) then
		local keepCrafting = (CraftingTool.doNonStopCraft or CraftingTool.doLimitedCraft)
		if(CraftingTool.currentSynth and gSMactive == "1") then -- Synth logic
				--[[
				itemID = synth.itemid
				--If it's a different item then set this stuff to def and change the id of the item
				if(CraftingTool.prevItemId ~= synth.itemid) then
					CraftingTool.prevItemId = synth.itemid
					CraftingTool.ProgressGain = 0
					CraftingTool.QualityGain = 0
					CraftingTool.FirstUse = false
					CraftingTool.FirstUseLevel = 0
				end
				-- I could simply calculate this each step to make sure that it works, but it seems better to not.
				if (CraftingTool.ProgressGain == 0 or CraftingTool.QualityGain == 0) then
					--d("Progress Prediction: ".. tostring(ProgressPrediction(tonumber(itemLevel), tonumber(craftsmanship))))
					--d("Quality Prediction: ".. tostring(QualityPrediction(tonumber(itemLevel), tonumber(control))))
					CraftingTool.ProgressGain = tonumber(ProgressPrediction(tonumber(itemLevel), tonumber(craftsmanship)))
					CraftingTool.QualityGain = tonumber(QualityPrediction(tonumber(itemLevel), tonumber(control)))
				end				
				local skill = SelectSkill(synth)
				if(skill) then
					lSkill = skill.name
					UseSkill(skill)
				end]]--
				
				gMWcrafting = "true"
				gMWitemid = CraftingTool.currentSynth.itemid
				
				if(CraftingTool.StartedCrafting and CraftingTool.craftsLeft > 0) then
					CraftingTool.craftsLeft = CraftingTool.craftsLeft - 1
					CraftingTool.StartedCrafting = false
				end
				
				local skill_list = CraftingTool.Profile.Skills
				local casted = false
				
				for i=1,TableSize(skill_list) do --Loop through all the skills and select a skill which has the lowest(best) priorty and meets all the criteria
					local skill = skill_list[i]
					local use = skill:Evaluate()
					--d("Spell id: " .. skill.id .. " Can Cast:" .. tostring(use))
					if(use) then
						casted = true
						skill:Use()
						gMWlastskill = skill:Get("name")
						d("< Casted: " .. gMWlastskill .. " >")
						CraftingTool.lastUse = ticks + skill.WaitTime
						break
					end
				end
				
				gMWiqstacks = CraftingTool.IQStacks
				
				if(not casted) then
					d("Can't cast anything please check that your profile is set up correctly")
				end
		elseif(keepCrafting) then
			if (not Crafting:IsCraftingLogOpen()) then
				Crafting:ToggleCraftingLog()
			else
				gMWcrafting = "false"
				gMWitemid = 0
				gMWiqstacks = 0
				gMWlastskill = "None"
				--gMWnq = "0"
				--gMWqh = "0"
				d("<< Crafting Item >>")
				Crafting:CraftSelectedItem()
				Crafting:ToggleCraftingLog()
				CraftingTool.lastUse = ticks + 4500
				CraftingTool.StartedCrafting = true
				if(CraftingTool.doLimitedCraft and CraftingTool.craftsLeft <= 1) then
					CraftingTool.doLimitedCraft = false
					Crafting:ToggleCraftingLog()
				end
			end
		end
	end
end

--[[ GUI Update ]]--
function CraftingTool.GUIVARUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if(k == "gSBprof") then 
			updateSkillBook()
		elseif(k == "gSMselectedProfile") then
			CraftingTool.Profile.Name = "None"
			CraftingTool.Profile.Prof = ""
			CraftingTool.Profile.Skills = CraftingTool.SkillList:New()
			readProfile()
		elseif(string.match(k, "gSV")) then 
			updateSkillFromView(k,v)
		elseif(k:match("gMW")) then
			Settings.CraftingTool[tostring(k)] = v
		end
	end
end

--[[ Module and Window Init ]]--
function CraftingTool.ModuleInit()
	--Init Global Variables for every profession
	_G[getProf(8)] = CraftingTool.SkillList:New(getSkills(getProf(8)))
	_G[getProf(9)] = CraftingTool.SkillList:New(getSkills(getProf(9)))
	_G[getProf(10)] = CraftingTool.SkillList:New(getSkills(getProf(10)))
	_G[getProf(11)] = CraftingTool.SkillList:New(getSkills(getProf(11)))
	_G[getProf(12)] = CraftingTool.SkillList:New(getSkills(getProf(12)))
	_G[getProf(13)] = CraftingTool.SkillList:New(getSkills(getProf(13)))
	_G[getProf(14)] = CraftingTool.SkillList:New(getSkills(getProf(14)))
	_G[getProf(15)] = CraftingTool.SkillList:New(getSkills(getProf(15)))
	_G["CrossClass"] = CraftingTool.SkillList:New(getSkills("CrossClass"))
	
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
	--[[Prof Selection
	GUI_NewComboBox(CraftingTool.mainwindow.name,"Profession","gMWCraftProf", "Profession Selection", "None")
	
	gMWCraftProf_listitems = ""
	for i,e in pairs(CraftingTool.cProf) do
		gMWCraftProf_listitems = gMWCraftProf_listitems..","..i
	end
	
	if (Settings.CraftingTool.gMWCraftProf == nil) then
		Settings.CraftingTool.gMWCraftProf = "Carpenter"
	end
	gMWCraftProf = Settings.CraftingTool.gMWCraftProf
	
	GUI_UnFoldGroup(CraftingTool.mainwindow.name,"Profession Selection")
	]]--
	
	--Info Window 
	GUI_NewField(CraftingTool.mainwindow.name,"Crafting","gMWcrafting", "Info")
	GUI_NewNumeric(CraftingTool.mainwindow.name,"Item ID","gMWitemid", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"","gMWempty", "Info")
	GUI_NewNumeric(CraftingTool.mainwindow.name,"IQ Stacks","gMWiqstacks", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"Last Skill","gMWlastskill", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"","gMWempty", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"NQ Crafted","gMWnq", "Info")
	GUI_NewField(CraftingTool.mainwindow.name,"HQ Crafted","gMWqh", "Info")
	gMWnq = "Unavailable"
	gMWqh = "Unavailable"
	--
	
	--Settings gMWcdelay
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Craftsmanship", "gMWCraftsmanship", "Settings")	
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Control", "gMWControl", "Settings")
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Recipe Level", "gMWRecipeLevel", "Settings")
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Custom Delay", "gMWcdelay", "Settings")
	
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
	if (Settings.CraftingTool.gMWcdelay == nil) then
		Settings.CraftingTool.gMWcdelay = "500"
	end
	gMWcdelay = Settings.CraftingTool.gMWcdelay
	
	--GUI_NewCheckbox(CraftingTool.mainwindow.name, "Use Quality", "gMWQuality", "Settings")
	--GUI_NewCheckbox(CraftingTool.mainwindow.name, "Use Durability", "gMWDurability", "Settings")
	--GUI_NewCheckbox(CraftingTool.mainwindow.name, "Use Buff", "gMWBuff", "Settings")
	--GUI_NewCheckbox(CraftingTool.mainwindow.name, "Use Skip", "gMWSkip", "Settings")
	
	if (Settings.CraftingTool.gMWQuality == nil) then
		Settings.CraftingTool.gMWQuality = "0"
	end
	gMWQuality = Settings.CraftingTool.gMWQuality
	if (Settings.CraftingTool.gMWDurability == nil) then
		Settings.CraftingTool.gMWDurability = "0"
	end
	gMWDurability = Settings.CraftingTool.gMWDurability
	if (Settings.CraftingTool.gMWBuff == nil) then
		Settings.CraftingTool.gMWBuff = "0"
	end
	gMWBuff = Settings.CraftingTool.gMWBuff
	if (Settings.CraftingTool.gMWSkip == nil) then
		Settings.CraftingTool.gMWSkip = "0"
	end
	gMWSkip = Settings.CraftingTool.gMWSkip
	
	GUI_UnFoldGroup(CraftingTool.mainwindow.name,"Settings")
	--
	
	--Craft Window
	GUI_NewNumeric(CraftingTool.mainwindow.name, "Craft Amount", "gMWCraftFor", "Craft")
	GUI_NewComboBox(CraftingTool.mainwindow.name,"How To Craft","gMWHowToCraft", "Craft", "Until Stopped,Single,Limited,Stop")
	gHowToCraft = "Until Stopped"
	GUI_NewButton(CraftingTool.mainwindow.name, "Start \\ Stop", "CraftingTool.Craft","Craft") 
	--
	
	--Buttons at the bottom
	GUI_NewButton(CraftingTool.mainwindow.name, "Skill Manager", "CraftingTool.SkillMngr") 
	--
	
	RegisterEventHandler("CraftingTool.Craft", CraftingTool.Craft)
	RegisterEventHandler("CraftingTool.SkillMngr", CraftingTool.SkillMngr)
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
	
	GUI_UnFoldGroup(CraftingTool.sbook.name,"Settings")
	
	updateSkillBook()
end

--Initialises SkillMngr Window
function SkillMngr()
	--Skill manager settings
	GUI_NewCheckbox(CraftingTool.smanager.name, "Active", "gSMactive", "Settings")
	GUI_NewComboBox(CraftingTool.smanager.name, "Profile","gSMselectedProfile", "Settings", " ")
	
	updateProfiles()
	
	if (Settings.CraftingTool.gSMactive == nil) then
		Settings.CraftingTool.gSMactive = "1"
	end
	gSMactive = Settings.CraftingTool.gSMactive
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
	readProfile()
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
	emptyS = s
	GUI_NewNumeric(CraftingTool.sview.name,"cp >=","gSVcpMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"cp <=","gSVcpMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"step >=","gSVstepMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"step <=","gSVstepMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"progress >=","gSVprogressMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"progress <=","gSVprogressMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"quality >=","gSVqualityMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"quality <=","gSVqualityMax", "Skill")--
	GUI_NewNumeric(CraftingTool.sview.name,"durability >=","gSVdurabilityMin", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"durability <=","gSVdurabilityMax", "Skill")--
	GUI_NewComboBox(CraftingTool.sview.name, "description","gSVdescription", "Skill", " ,Poor, Normal, Good, Excellent")
	
	GUI_NewNumeric(CraftingTool.sview.name,"Buff Present","gSVbuffid", "Skill")
	GUI_NewNumeric(CraftingTool.sview.name,"Buff Not Present","gSVnotbuffid", "Skill")
	
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
	local Skills = _G[gSBprof]

	for i,e in pairs(CraftingTool.cActionType) do
		GUI_DeleteGroup(CraftingTool.sbook.name,e.." List")
	end
	
	if(Skills) then
		for i=1,#Skills do
			local skill = CraftingTool.Skill:New(Skills[i], nil, false) -- skill table, condition table, whether CC or not
			addSkillBookEntry(skill)
		end
	end	
end
function addSkillBookEntry ( skill )
	if (skill) then
		local sname = skill.name
		
		GUI_NewButton(CraftingTool.sbook.name, sname, sname, skill.actionType.." List")
		
		if ( CraftingTool.EventsRegistered[sname] == nil ) then
			RegisterEventHandler( sname, CraftingTool.AddSkillToProfile)
			CraftingTool.EventsRegistered[sname] = 1
		end	
		
		CraftingTool.SkillBook[sname] = skill
	end
end
function CraftingTool.AddSkillToProfile( sname )
	local skill = CraftingTool.SkillBook[sname]
	skill.prio = TableSize(CraftingTool.Profile.Skills) + 1
	if (skill ~= nil) then
		if(CraftingTool.Profile.Name and CraftingTool.Profile.Name ~= "" and CraftingTool.Profile.Name ~= "None") then
			skill["on"] = "1"
			value = 0
			for e,i in pairs({ "iqstacks", "cp", "step", "progress", "quality", "durability", "description", "buff", "notbuff" }) do
				if(i == "description") then
					if(skill:FindCondition(i, "None") == nil) then skill:AddCondition(CraftingTool.Condition:New(i, " ")) end
				elseif(i == "buff" or i == "notbuff") then
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
	end
end

--[[ Skill Manager Functions ]]--
function CraftingTool.AddSkillManagerEntry(skill)
	if (skill) then
		local sname = skill.name
		
		local i = 0
		while(( CraftingTool.EventsRegistered[sname.."["..i.."]"] ~= nil )) do
			i = i + 1
		end
		sname = sname .. "["..i.."]"
		
		GUI_NewButton(CraftingTool.smanager.name, sname, sname, "Skill List")
		RegisterEventHandler( sname, CraftingTool.SkillView)
		CraftingTool.EventsRegistered[sname] = 1
	end
end
function newProfile()
	if(gSMnewProfileName and gSMnewProfileName ~= "" and gSMnewProfileName ~= "None") then
		gSMselectedProfile_listitems = gSMselectedProfile_listitems..","..gSMnewProfileName
		gSMselectedProfile = gSMnewProfileName
		CraftingTool.Profile.Name = gSMselectedProfile
		CraftingTool.Profile.Prof = gSBprof
		writeProfile()
		readProfile()
	end
end
function readProfile()
	GUI_DeleteGroup(CraftingTool.smanager.name, "Skill List")
	Settings.CraftingTool.gSMselectedProfile = gSMselectedProfile
	d("Opening Profile: "..gSMselectedProfile)
	if ( gSMselectedProfile and gSMselectedProfile ~= "") then
		local profile = fileread(CraftingTool.profilepath..gSMselectedProfile..".lua")
		if ( TableSize(profile) > 0) then
			local prof = ""
			local unsortedList = CraftingTool.SkillList:New()
			local skillList = CraftingTool.SkillList:New()
			local skill = {}
			
			for i,line in pairs(profile) do
				local _, key, value = string.match(line, "(%w+)_(%w+)=(.*)")
				key = key:lower()
				if(key and value and key ~= "" and value ~= "") then
					--d(_.." "..key.." "..value)
					if(key == "prof" and value and value ~= "") then
						prof = value 
					elseif(key == "id") then
						if(_G[prof]) then
							skill = _G[prof]:getSkillById(tonumber(value))
							if(skill == nil or skill.name == nil) then
								if(_G["CrossClass"]) then skill = _G["CrossClass"]:getSkillById(tonumber(value)) end
							end
						end
					elseif(key=="name" or key=="on" or key=="prio") then
						skill[key] = value
					elseif(key == "end") then
						--d(skill.id .. " " .. skill.name)
						unsortedList:Add(skill)
						skill = {}
						skillname = ""
					else
						local cType = key
						local cCond = "None"
						if(string.match(key, "min")) then
							cType = key:gsub("min", "")
							cCond = "<="
						elseif(string.match(key, "max")) then
							cType = key:gsub("max", "")
							cCond = ">="
						elseif(string.match(key, "iqstacks")) then
							cCond = ">="
						end
						--d(cType .. " " .. value .. " " .. cCond)
						skill:AddCondition(CraftingTool.Condition:New(cType, tonumber(value), cCond))
					end
				end
			end	
			
			CraftingTool.Profile.Name = gSMselectedProfile
			CraftingTool.Profile.Prof = prof
			
			--GUI call and sort
			if ( TableSize(unsortedList) > 0 ) then
				local i,skill = next (unsortedList)
				while i and skill do
					skillList:Add( skill )
					i,skill = next (unsortedList,i)
				end
				table.sort(skillList, function(a,b) return a.prio < b.prio end )	
				
				CraftingTool.Profile.Skills = skillList
				
				for i = 1,#skillList do					
					if (skillList[i] ~= nil ) then
						--d(skillList[i].id .. " " .. skillList[i].name)
						CraftingTool.AddSkillManagerEntry(skillList[i])
					end
				end
			end
		end
	end
	GUI_UnFoldGroup(CraftingTool.smanager.name, "Skill List")
	GUI_WindowVisible(CraftingTool.sview.name,false)
end
function writeProfile()
	local filename = gSMselectedProfile
	local filepath = "" --CraftingTool.profilepath..filename..".lua"
	
	if ((gSMselectedProfile ~= nil and gSMselectedProfile ~= "None" and gSMselectedProfile ~= "")) then
		filepath = CraftingTool.profilepath..filename..".lua"
	end
	
	if(filepath ~= "") then
		d("Saving the crafting profile into: "..filename)
		d("Full path: "..filepath)
		local writeStr = "CT_Prof="..gSBprof.."\n"
		for i, skill in pairs(CraftingTool.Profile.Skills) do
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
			
			writeStr = writeStr.."CT_DESCRIPTION="..skill:FindCondition( "description", "None").."\n"
			writeStr = writeStr.."CT_BUFF="..skill:FindCondition( "buff", "None").."\n"
			writeStr = writeStr.."CT_NOTBUFF="..skill:FindCondition( "notbuff", "None").."\n"
			
			writeStr = writeStr.."CT_END=0\n"
		end
		d(filewrite(filepath,writeStr))
	end
end
function updateProfiles()
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

--[[ Skill View Functions ]]--
function updateSkillFromView( varname, value ) -- Updates the skill inside the Profile. Not the file.
	--d("List Position: "..id.." Skill ID: "..gSVid .. " VarName: " .. varname)
	local id = CraftingTool.Profile.Skills:getListPos(CraftingTool.Profile.Skills:getSkillById(tonumber(gSVid)))
	if(id ~= 0) then
		local key = string.match(varname, "gSV(%w+)")
		key = key:lower()
		local ctype = "None"
			
		if(string.match(key, 'min') or string.match(key, 'max')) then
			ctype = (string.match(key, 'min') and "<=" or ">=")
			key = key:gsub('min', ''):gsub('max', '')
		end
		
		--d("Skill Name: ".. CraftingTool.Profile.Skills[id].name.." => "..key .. " => " .. value .. " " .. ctype .. " Player Value")
		
		if(key == "id" or key=="name" or key=="on" or key=="prio") then
			CraftingTool.Profile.Skills[id][key] = value
		else
			CraftingTool.Profile.Skills[id]:FindCondition(key, ctype, tonumber(value))
		end
	end
end
function CraftingTool.UpdateView ( skill )
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
		local description	= skill:FindCondition( "description", "None" ) or "None"
		local buffid		= skill:FindCondition( "buff", "None" ) or 0
		local notbuffid		= skill:FindCondition( "notbuff", "None" ) or 0
		
		--[[d("----------")
		d(id)
		d(name)
		d(prio)
		d(iqstacks)
		d(cpMin)
		d(cpMax)
		d(stepMin)
		d(stepMax)
		d(progressMin)
		d(progressMax)
		d(qualityMin)
		d(qualityMax)
		d(durabilityMin)
		d(durabilityMax)
		d(description)
		d(buffid)
		d(notbuffid)
		d("----------")]]--
		
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
		gSVdescription	 = description
		gSVbuffid		 = buffid
		gSVnotbuffid	 = notbuffid
		
		GUI_WindowVisible(CraftingTool.sview.name,true)
	end
end

--[[ Button Handlers ]]--
function CraftingTool.Craft( dir )
	CraftingTool.doNonStopCraft = false
	CraftingTool.doLimitedCraft = false
	
	if(gMWHowToCraft == "Non Stop") then
		CraftingTool.doNonStopCraft = true
		gMWHowToCraft = "Stop"
	elseif(gMWHowToCraft == "Single") then
		CraftingTool.craftsLeft = 1
		CraftingTool.doLimitedCraft = true
	elseif(gMWHowToCraft == "Limited") then
		CraftingTool.craftsLeft = tonumber(gMWCraftFor)
		CraftingTool.doLimitedCraft = true
	end
end

function CraftingTool.SkillMngr( dir )
	GUI_WindowVisible(CraftingTool.smanager.name,true)
end

function CraftingTool.SkillView( sname )
	sname = sname:gsub("%[(%d+)%]", "")
	local skill = CraftingTool.Profile.Skills:getSkillByName(sname)
	d("Skill Level: " .. skill:FindCondition("level","<="))
	CraftingTool.UpdateView(skill)
end

function CraftingTool.SkillManagerHandler( dir )
	if(dir == "Create New") then
		newProfile()
	elseif(dir == "Skill Book") then
		GUI_WindowVisible(CraftingTool.sbook.name,true)
	elseif(dir == "Save Profile") then
		writeProfile()
	end
end

function CraftingTool.SkillViewHandler( dir )
	if(dir == "DELETE") then
		if ( TableSize(CraftingTool.Profile.Skills) > 0 ) then
			GUI_DeleteGroup(CraftingTool.smanager.name,"Skill List")
			CraftingTool.Profile.Skills:Remove(CraftingTool.Profile.Skills:getSkillById(tonumber(gSVid)))
			writeProfile()
			readProfile()
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

function StepSucceeded( params ) -- Returns a boolean signifying success of the last step taken
end

function PlayerHasBuff(id) -- Returns a buffid of the buff needing to be recast
	local hasBuff = false
	if (Player) then
		local pbuffs = Player.buffs
		if ( pbuffs  and TableSize(pbuffs) > 0) then
			for i=0,TableSize(pbuffs) do
				local buff = pbuffs[i]
				if ( buff ) then
					if(buff.id == id) then 
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