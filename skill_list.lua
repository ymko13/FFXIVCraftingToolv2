--This file contains functions which return a skill list for a certain profession

function getSkills( prof ) -- gets the skills for a certain prof
	if(prof == "Carpenter") then return getCarpenterSkills() end
	if(prof == "Weaver") then return getWeaverSkills() end
	--[[
	if(prof == "Blacksmith") then return getBlacksmithSkills() end
	if(prof == "Armourer") then return getArmourerSkills() end
	if(prof == "Goldsmith") then return getGoldsmithSkills() end
	if(prof == "Leatherworker") then return getLeatherworkerSkills() end
	if(prof == "Alchemist") then return getAlchemistSkills() end
	if(prof == "Culinary") then return getCulinarySkills() end
	if(prof == "CrossClass") then return getCrossClassSkills() end--]]
	return {}
end

function getCarpenterSkills()
	local Skills = {
		{ ["id"] = 244, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 252, 	["name"] = "Inner Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 276, 	["name"] = "Rumination",			["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Buff", 		["buffid"] = "276" },
		{ ["id"] = 260, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "32", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 100001, 	["name"] = "Basic Synthesis", 		["level"] = "1", 	["cost"] = "0", 	["actionType"] = "Progress",	["efficiency"] = "100", ["chance"] = "90" },
		{ ["id"] = 100007, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress",	["efficiency"] = "150", ["chance"] = "90" },
		{ ["id"] = 100006, 	["name"] = "Brand Of Wind", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress",	["efficiency"] = "200", ["chance"] = "90" },
		{ ["id"] = 100002, 	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18", 	["actionType"] = "Quality", 	["efficiency"] = "100", ["chance"] = "70" },
		{ ["id"] = 100004, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", ["chance"] = "80" },
		{ ["id"] = 100008, 	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", ["chance"] = "90" },
		{ ["id"] = 100009, 	["name"] = "Byregot's Blessing", 	["level"] = "50", 	["cost"] = "24", 	["actionType"] = "Quality", 	["efficiency"] = "100", ["chance"] = "90"  },
		{ ["id"] = 100003, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92", 	["actionType"] = "Durability", 	["efficiency"] = "30" },
		{ ["id"] = 100005, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160",	["actionType"] = "Durability", 	["efficiency"] = "60" },
		{ ["id"] = 100010, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" }
	}
	return Skills;
end

function getWeaverSkills()
	local Skills = {
		{ ["id"] = 248, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22",	["actionType"] = "Buff", 		["buffid"] = "253" }, --1
		{ ["id"] = 256, 	["name"] = "Inner Quiet", 			["level"] = "11", 	["cost"] = "18",	["actionType"] = "Buff", 		["buffid"] = "251" }, --2
		{ ["id"] = 264, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "32",	["actionType"] = "Buff", 		["buffid"] = "254" }, --3
		{ ["id"] = 100063, 	["name"] = "Careful Synthesis", 	["level"] = "15", 	["cost"] = "0",		["actionType"] = "Progress",	["efficiency"] = "90", 	["chance"] = "100" }, --4
		{ ["id"] = 100060, 	["name"] = "Basic Synthesis", 		["level"] = "1", 	["cost"] = "0",		["actionType"] = "Progress",	["efficiency"] = "100", ["chance"] = "90", }, --5
		{ ["id"] = 100069, 	["name"] = "Careful Synthesis II", 	["level"] = "50", 	["cost"] = "0",		["actionType"] = "Progress",	["efficiency"] = "120", ["chance"] = "100" }, --6
		{ ["id"] = 100067, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15",	["actionType"] = "Progress",	["efficiency"] = "150", ["chance"] = "90" }, --7
		{ ["id"] = 100066, 	["name"] = "Brand of Lightning", 	["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress",	["efficiency"] = "200", ["chance"] = "90" }, --8
		{ ["id"] = 100061,	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18",	["actionType"] = "Quality", 	["efficiency"] = "100", ["chance"] = "70" }, --9
		{ ["id"] = 100064,	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", ["chance"] = "70" }, --10
		{ ["id"] = 100068,	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", ["chance"] = "90" }, --11
		{ ["id"] = 100062,	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92",	["actionType"] = "Durability", 	["efficiency"] = "30" }, --12
		{ ["id"] = 100065,	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60" }, --13
		{ ["id"] = 100070,	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14",	["actionType"] = "Skip" } --14
	}
	return Skills;
end

function getBlacksmithSkills() -- needs update
	local Skills = {
		["100015"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "100", ["chance"] = "90", ["name"] = "Basic Synthesis", ["level"] = "1", ["cost"] = "0" },
		["100016"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "70", ["name"] = "Basic Touch", ["level"] = "5", ["cost"] = "18" },
		["100017"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "30", ["chance"] = "30", ["name"] = "Master's Mend", ["level"] = "7", ["cost"] = "92" },
		["245"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "253", ["name"] = "Steady Hand", ["level"] = "9", ["cost"] = "22" },
		["253"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "251", ["name"] = "Inner-Quiet", ["level"] = "11", ["cost"] = "18" },
		["100023"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "1", ["chance"] = "100", ["name"] = "Observe", ["level"] = "13", ["cost"] = "14" },
		["277"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "255", ["name"] = "Ingenuity", ["level"] = "15", ["cost"] = "24" },
		["100018"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "125", ["chance"] = "80", ["name"] = "Standard Touch", ["level"] = "18", ["cost"] = "32" },
		["261"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "200", ["chance"] = "0", ["buffid"] = "254", ["name"] = "Great Strides", ["level"] = "21", ["cost"] = "0" },
		["100019"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "60", ["chance"] = "60", ["name"] = "Master's Mend II", ["level"] = "25", ["cost"] = "160" },
		["100021"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Standard Synthesis", ["level"] = "31", ["cost"] = "15" },
		["100020"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "200", ["chance"] = "90", ["name"] = "Brand of Fire", ["level"] = "37", ["cost"] = "15" },
		["100022"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Advanced Touch", ["level"] = "43", ["cost"] = "48" },
		["283"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "256", ["name"] = "Ingenuity II", ["level"] = "50", ["cost"] = "32"  }
	}
	return Skills;
end

function getArmourerSkills() -- needs update
	local Skills = {
		["100030"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "100", ["chance"] = "90", ["name"] = "Basic Synthesis", ["level"] = "1", ["cost"] = "0" },
		["100031"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "70", ["name"] = "Basic Touch", ["level"] = "5", ["cost"] = "18" },
		["100032"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "30", ["chance"] = "30", ["name"] = "Master's Mend", ["level"] = "7", ["cost"] = "92" },
		["246"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "253", ["name"] = "Steady Hand", ["level"] = "9", ["cost"] = "22" },
		["254"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "251", ["name"] = "Inner-Quiet", ["level"] = "11", ["cost"] = "18" },
		["100040"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "1", ["chance"] = "100", ["name"] = "Observe", ["level"] = "13", ["cost"] = "14" },
		["100033"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "250", ["chance"] = "50", ["name"] = "Rapid Synthesis", ["level"] = "15", ["cost"] = "0" },
		["100034"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "125", ["chance"] = "80", ["name"] = "Standard Touch", ["level"] = "18", ["cost"] = "32" },
		["262"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "200", ["chance"] = "0", ["buffid"] = "254", ["name"] = "Great Strides", ["level"] = "21", ["cost"] = "0" },
		["100035"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "60", ["chance"] = "60", ["name"] = "Master's Mend II", ["level"] = "25", ["cost"] = "160" },
		["100037"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Standard Synthesis", ["level"] = "31", ["cost"] = "15" },
		["100036"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "200", ["chance"] = "90", ["name"] = "Brand of Ice", ["level"] = "37", ["cost"] = "15" },
		["100038"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Advanced Touch", ["level"] = "43", ["cost"] = "48" },
		["100039"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "0", ["chance"] = "90", ["name"] = "Piece By Piece", ["level"] = "50", ["cost"] = "15"  }
	}
	return Skills;
end

function getGoldsmithSkills() -- needs update
	local Skills = {
		["100075"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "100", ["chance"] = "90", ["name"] = "Basic Synthesis", ["level"] = "1", ["cost"] = "0" },
		["100076"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "70", ["name"] = "Basic Touch", ["level"] = "5", ["cost"] = "18" },
		["100077"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "30", ["chance"] = "30", ["name"] = "Master's Mend", ["level"] = "7", ["cost"] = "92" },
		["247"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "253", ["name"] = "Steady Hand", ["level"] = "9", ["cost"] = "22" },
		["255"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "251", ["name"] = "Inner-Quiet", ["level"] = "11", ["cost"] = "18" },
		["100082"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "1", ["chance"] = "100", ["name"] = "Observe", ["level"] = "13", ["cost"] = "14" },
		["278"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "30", ["chance"] = "0", ["buffid"] = "258", ["name"] = "Manipulation", ["level"] = "15", ["cost"] = "88" },
		["100078"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "125", ["chance"] = "80", ["name"] = "Standard Touch", ["level"] = "18", ["cost"] = "32" },
		["263"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "200", ["chance"] = "0", ["buffid"] = "254", ["name"] = "Great Strides", ["level"] = "21", ["cost"] = "0" },
		["100079"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "60", ["chance"] = "60", ["name"] = "Master's Mend II", ["level"] = "25", ["cost"] = "160" },
		["100080"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Standard Synthesis", ["level"] = "31", ["cost"] = "15" },
		["100083"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "0", ["chance"] = "90", ["name"] = "Flawless Synthesis", ["level"] = "37", ["cost"] = "15" },
		["100081"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Advanced Touch", ["level"] = "43", ["cost"] = "48" },
		["284"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "50", ["chance"] = "0", ["buffid"] = "259", ["name"] = "Innovation", ["level"] = "50", ["cost"] = "18"  }
	}
	return Skills;
end

function getLeatherworkerSkills() -- needs update
	local Skills = {
		["100045"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "100", ["chance"] = "90", ["name"] = "Basic Synthesis", ["level"] = "1", ["cost"] = "0" },
		["100046"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "70", ["name"] = "Basic Touch", ["level"] = "5", ["cost"] = "18" },
		["100047"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "30", ["chance"] = "30", ["name"] = "Master's Mend", ["level"] = "7", ["cost"] = "92" },
		["249"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "253", ["name"] = "Steady Hand", ["level"] = "9", ["cost"] = "22" },
		["257"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "251", ["name"] = "Inner-Quiet", ["level"] = "11", ["cost"] = "18" },
		["100053"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "1", ["chance"] = "100", ["name"] = "Observe", ["level"] = "13", ["cost"] = "14" },
		["279"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "100", ["buffid"] = "252", ["name"] = "Waste Not", ["level"] = "15", ["cost"] = "56" },
		["100048"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "125", ["chance"] = "80", ["name"] = "Standard Touch", ["level"] = "18", ["cost"] = "32" },
		["265"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "200", ["chance"] = "90", ["buffid"] = "254", ["name"] = "Great Strides", ["level"] = "21", ["cost"] = "32" },
		["100049"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "60", ["chance"] = "60", ["name"] = "Master's Mend II", ["level"] = "25", ["cost"] = "160" },
		["100051"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Standard Synthesis", ["level"] = "31", ["cost"] = "15" },
		["100050"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "200", ["chance"] = "90", ["name"] = "Brand Of Earth", ["level"] = "37", ["cost"] = "15" },
		["100052"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Advanced Touch", ["level"] = "43", ["cost"] = "48" },
		["285"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "90", ["buffid"] = "257", ["name"] = "Waste Not II", ["level"] = "50", ["cost"] = "98"  }
	}
	return Skills;
end

function getAlchemistSkills() -- needs update
	local Skills = {
		["100090"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "100", ["chance"] = "90", ["name"] = "Basic Synthesis", ["level"] = "1", ["cost"] = "0" },
		["100091"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "70", ["name"] = "Basic Touch", ["level"] = "5", ["cost"] = "18" },
		["100092"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "30", ["chance"] = "30", ["name"] = "Master's Mend", ["level"] = "7", ["cost"] = "92" },
		["250"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "253", ["name"] = "Steady Hand", ["level"] = "9", ["cost"] = "22" },
		["258"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "251", ["name"] = "Inner Quiet", ["level"] = "11", ["cost"] = "18" },
		["100099"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "1", ["chance"] = "100", ["name"] = "Observe", ["level"] = "13", ["cost"] = "14" },
		["100098"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "20", ["chance"] = "100", ["name"] = "Tricks Of The Trade", ["level"] = "15", ["cost"] = "0" },
		["100093"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "125", ["chance"] = "80", ["name"] = "Standard Touch", ["level"] = "18", ["cost"] = "32" },
		["266"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "200", ["chance"] = "0", ["buffid"] = "254", ["name"] = "Great Strides", ["level"] = "21", ["cost"] = "0" },
		["100094"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "60", ["chance"] = "60", ["name"] = "Master's Mend II", ["level"] = "25", ["cost"] = "160" },
		["100096"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Standard Synthesis", ["level"] = "31", ["cost"] = "15" },
		["100095"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "200", ["chance"] = "90", ["name"] = "Brand of Water", ["level"] = "37", ["cost"] = "15" },
		["100097"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Advanced Touch", ["level"] = "43", ["cost"] = "48" },
		["286"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "261", ["name"] = "Comfort Zone", ["level"] = "50", ["cost"] = "66"  }
	}
	return Skills;
end

function getCulinarySkills() -- needs update
	local Skills = {
		["100105"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "100", ["chance"] = "90", ["name"] = "Basic Synthesis", ["level"] = "1", ["cost"] = "0" },
		["100106"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "70", ["name"] = "Basic Touch", ["level"] = "5", ["cost"] = "18" },
		["100107"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "30", ["chance"] = "30", ["name"] = "Master's Mend", ["level"] = "7", ["cost"] = "92" },
		["251"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "253", ["name"] = "Steady Hand", ["level"] = "9", ["cost"] = "22" },
		["259"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "251", ["name"] = "Inner Quiet", ["level"] = "11", ["cost"] = "18" },
		["100113"] = { ["id"] = 248, ["actionType"] = "Skip", ["efficiency"] = "1", ["chance"] = "100", ["name"] = "Observe", ["level"] = "13", ["cost"] = "14" },
		["100108"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "100", ["chance"] = "50", ["name"] = "Hasty Touch", ["level"] = "15", ["cost"] = "0" },
		["100109"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "125", ["chance"] = "80", ["name"] = "Standard Touch", ["level"] = "18", ["cost"] = "32" },
		["267"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "200", ["chance"] = "0", ["buffid"] = "254", ["name"] = "Great Strides", ["level"] = "21", ["cost"] = "32" },
		["100110"] = { ["id"] = 248, ["actionType"] = "Durability", ["efficiency"] = "60", ["chance"] = "60", ["name"] = "Master's Mend II", ["level"] = "25", ["cost"] = "160" },
		["100111"] = { ["id"] = 248, ["actionType"] = "Progress", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Standard Synthesis", ["level"] = "31", ["cost"] = "15" },
		["281"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "0", ["buffid"] = "262", ["name"] = "Steady Hand II", ["level"] = "37", ["cost"] = "25" },
		["100112"] = { ["id"] = 248, ["actionType"] = "Quality", ["efficiency"] = "150", ["chance"] = "90", ["name"] = "Advanced Touch", ["level"] = "43", ["cost"] = "48" },
		["287"] = { ["id"] = 248, ["actionType"] = "Buff", ["efficiency"] = "0", ["chance"] = "90", ["buffid"] = "260", ["name"] = "Reclaim", ["level"] = "50", ["cost"] = "55"  }
	}
	return Skills;
end

function getCrossClassSkills() -- needs update
	local Skills = {
		
	}
	return Skills;
end

