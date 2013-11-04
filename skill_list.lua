--This file contains functions which return a skill list for a certain profession
function getSkills( prof ) -- gets the skills for a certain prof
	if(prof == "Carpenter") then return getCarpenterSkills() end
	if(prof == "Weaver") then return getWeaverSkills() end
	if(prof == "Blacksmith") then return getBlacksmithSkills() end
	if(prof == "Armourer") then return getArmourerSkills() end
	if(prof == "Goldsmith") then return getGoldsmithSkills() end
	if(prof == "Leatherworker") then return getLeatherworkerSkills() end
	if(prof == "Alchemist") then return getAlchemistSkills() end
	if(prof == "Culinary") then return getCulinarySkills() end
	if(prof == "CrossClass") then return getCrossClassSkills() end
	return {}
end

function getCarpenterSkills()
	local Skills = {
		{ ["id"] = 252, 	["name"] = "Inner Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 244, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 260, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "32", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 276, 	["name"] = "Rumination",			["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Buff", 		["buffid"] = "276" },
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
		{ ["id"] = 256, 	["name"] = "Inner Quiet", 			["level"] = "11", 	["cost"] = "18",	["actionType"] = "Buff", 		["buffid"] = "251" }, --1
		{ ["id"] = 248, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22",	["actionType"] = "Buff", 		["buffid"] = "253" }, --2
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

function getBlacksmithSkills()
	local Skills = {
		{ ["id"] = 253, 	["name"] = "Inner-Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff",		["buffid"] = "251" },
		{ ["id"] = 245, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff",		["buffid"] = "253" },
		{ ["id"] = 261, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "0", 	["actionType"] = "Buff",		["buffid"] = "254" },
		{ ["id"] = 277, 	["name"] = "Ingenuity", 			["level"] = "15", 	["cost"] = "24", 	["actionType"] = "Buff",		["buffid"] = "255" },
		{ ["id"] = 283, 	["name"] = "Ingenuity II", 			["level"] = "50", 	["cost"] = "32", 	["actionType"] = "Buff",		["buffid"] = "256" },
		{ ["id"] = 100015, 	["name"] = "Basic Synthesis", 		["level"] = "1",	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "100", ["chance"] = "90" },
		{ ["id"] = 100021, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "150", ["chance"] = "90" },
		{ ["id"] = 100020, 	["name"] = "Brand of Fire", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", ["chance"] = "90" },
		{ ["id"] = 100016, 	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18", 	["actionType"] = "Quality", 	["efficiency"] = "100", ["chance"] = "70" },
		{ ["id"] = 100018, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", ["chance"] = "80" },
		{ ["id"] = 100022, 	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", ["chance"] = "90" },
		{ ["id"] = 100017, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92", 	["actionType"] = "Durability", 	["efficiency"] = "30" },
		{ ["id"] = 100019, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60" },
		{ ["id"] = 100023, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" }
	}
	return Skills;
end

function getArmourerSkills()
	local Skills = {
		{ ["id"] = 254, 	["name"] = "Inner-Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 246, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 262, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "0", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 100039, 	["name"] = "Piece By Piece", 		["level"] = "50", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "0", 		["chance"] = "90" },
		{ ["id"] = 100030, 	["name"] = "Basic Synthesis",		["level"] = "1", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "100", 	["chance"] = "90" },
		{ ["id"] = 100037, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100036, 	["name"] = "Brand of Ice", 			["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", 	["chance"] = "90" },
		{ ["id"] = 100033, 	["name"] = "Rapid Synthesis", 		["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "250", 	["chance"] = "50" },
		{ ["id"] = 100031, 	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18", 	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "70" },
		{ ["id"] = 100034, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", 	["chance"] = "80" },
		{ ["id"] = 100038, 	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100032, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92", 	["actionType"] = "Durability", 	["efficiency"] = "30" },
		{ ["id"] = 100035, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60" },
		{ ["id"] = 100040, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" }
	}
	return Skills;
end

function getGoldsmithSkills()
	local Skills = {
		{ ["id"] = 255, 	["name"] = "Inner-Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 247, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 263, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "0", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 278, 	["name"] = "Manipulation", 			["level"] = "15", 	["cost"] = "88", 	["actionType"] = "Buff", 		["buffid"] = "258" },
		{ ["id"] = 284, 	["name"] = "Innovation", 			["level"] = "50", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "259" },
		{ ["id"] = 100083, 	["name"] = "Flawless Synthesis", 	["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "0", 		["chance"] = "90" },
		{ ["id"] = 100075, 	["name"] = "Basic Synthesis", 		["level"] = "1", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "100", 	["chance"] = "90" },
		{ ["id"] = 100080, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100076,	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18",	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "70" },
		{ ["id"] = 100078, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", 	["chance"] = "80" },
		{ ["id"] = 100081, 	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100077, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92",	["actionType"] = "Durability", 	["efficiency"] = "30" },
		{ ["id"] = 100079, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60" },
		{ ["id"] = 100082, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" },
	}
	return Skills;
end

function getLeatherworkerSkills()
	local Skills = {
		{ ["id"] = 257, 	["name"] = "Inner-Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 279, 	["name"] = "Waste Not", 			["level"] = "15", 	["cost"] = "56", 	["actionType"] = "Buff", 		["buffid"] = "252" },
		{ ["id"] = 249, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 265, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "32", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 285, 	["name"] = "Waste Not II", 			["level"] = "50", 	["cost"] = "98", 	["actionType"] = "Buff", 		["buffid"] = "257" },
		{ ["id"] = 100045, 	["name"] = "Basic Synthesis", 		["level"] = "1", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "100", 	["chance"] = "90" },
		{ ["id"] = 100051, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100050,	["name"] = "Brand Of Earth", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", 	["chance"] = "90" },
		{ ["id"] = 100046, 	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18", 	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "70" },
		{ ["id"] = 100048, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", 	["chance"] = "80" },
		{ ["id"] = 100052, 	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100047, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92", 	["actionType"] = "Durability", 	["efficiency"] = "30", 		["chance"] = "30" },
		{ ["id"] = 100049, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60", 		["chance"] = "60" },
		{ ["id"] = 100053, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" }
	}
	return Skills;
end

function getAlchemistSkills()
	local Skills = {
		{ ["id"] = 258, 	["name"] = "Inner Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 250, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 266, 	["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "0", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 286, 	["name"] = "Comfort Zone", 			["level"] = "50", 	["cost"] = "66", 	["actionType"] = "Buff", 		["buffid"] = "261" },
		{ ["id"] = 100090, 	["name"] = "Basic Synthesis", 		["level"] = "1", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "100", 	["chance"] = "90" },
		{ ["id"] = 100096, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100095, 	["name"] = "Brand of Water", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", 	["chance"] = "90" },
		{ ["id"] = 100091, 	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18", 	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "70" },
		{ ["id"] = 100093, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality",		["efficiency"] = "125", 	["chance"] = "80" },
		{ ["id"] = 100097, 	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality",		["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100092, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92", 	["actionType"] = "Durability", 	["efficiency"] = "30" },
		{ ["id"] = 100094, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60" },
		{ ["id"] = 100099, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" },
		{ ["id"] = 100098, 	["name"] = "Tricks Of The Trade", 	["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Skip" }
	}
	return Skills;
end

function getCulinarySkills()
	local Skills = {
		{ ["id"] = 259, 	["name"] = "Inner Quiet", 			["level"] = "11", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "251" },
		{ ["id"] = 251, 	["name"] = "Steady Hand", 			["level"] = "9", 	["cost"] = "22", 	["actionType"] = "Buff", 		["buffid"] = "253" },
		{ ["id"] = 267,		["name"] = "Great Strides", 		["level"] = "21", 	["cost"] = "32", 	["actionType"] = "Buff", 		["buffid"] = "254" },
		{ ["id"] = 287, 	["name"] = "Reclaim", 				["level"] = "50", 	["cost"] = "55", 	["actionType"] = "Buff", 		["buffid"] = "260" },
		{ ["id"] = 281, 	["name"] = "Steady Hand II", 		["level"] = "37", 	["cost"] = "25", 	["actionType"] = "Buff", 		["buffid"] = "262" },
		{ ["id"] = 100105, 	["name"] = "Basic Synthesis", 		["level"] = "1", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "100", 	["chance"] = "90" },
		{ ["id"] = 100111, 	["name"] = "Standard Synthesis", 	["level"] = "31", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100106, 	["name"] = "Basic Touch", 			["level"] = "5", 	["cost"] = "18", 	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "70" },
		{ ["id"] = 100108, 	["name"] = "Hasty Touch", 			["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "50" },
		{ ["id"] = 100109, 	["name"] = "Standard Touch", 		["level"] = "18", 	["cost"] = "32", 	["actionType"] = "Quality", 	["efficiency"] = "125", 	["chance"] = "80" },
		{ ["id"] = 100112,	["name"] = "Advanced Touch", 		["level"] = "43", 	["cost"] = "48", 	["actionType"] = "Quality", 	["efficiency"] = "150", 	["chance"] = "90" },
		{ ["id"] = 100107, 	["name"] = "Master's Mend", 		["level"] = "7", 	["cost"] = "92", 	["actionType"] = "Durability", 	["efficiency"] = "30" },
		{ ["id"] = 100110, 	["name"] = "Master's Mend II", 		["level"] = "25", 	["cost"] = "160", 	["actionType"] = "Durability", 	["efficiency"] = "60" },
		{ ["id"] = 100113, 	["name"] = "Observe", 				["level"] = "13", 	["cost"] = "14", 	["actionType"] = "Skip" }
	}
	return Skills;
end

function getCrossClassSkills()
	local Skills = {
		["Carpenter"] = { 		{ ["id"] = 276, 	["name"] = "Rumination",			["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Buff", 		["buffid"] = "276" },
								{ ["id"] = 100006, 	["name"] = "Brand Of Wind", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress",	["efficiency"] = "200", ["chance"] = "90" },
								{ ["id"] = 100009, 	["name"] = "Byregot's Blessing", 	["level"] = "50", 	["cost"] = "24", 	["actionType"] = "Quality", 	["efficiency"] = "100", ["chance"] = "90" }	},
								
		["Weaver"] = {			{ ["id"] = 100063, 	["name"] = "Careful Synthesis", 	["level"] = "15", 	["cost"] = "0",		["actionType"] = "Progress",	["efficiency"] = "90", 	["chance"] = "100" },
								{ ["id"] = 100066, 	["name"] = "Brand of Lightning", 	["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress",	["efficiency"] = "200", ["chance"] = "90" },
								{ ["id"] = 100069, 	["name"] = "Careful Synthesis II", 	["level"] = "50", 	["cost"] = "0",		["actionType"] = "Progress",	["efficiency"] = "120", ["chance"] = "100" } },
								
		["Blacksmith"] = {		{ ["id"] = 277, 	["name"] = "Ingenuity", 			["level"] = "15", 	["cost"] = "24", 	["actionType"] = "Buff",		["buffid"] = "255" },
								{ ["id"] = 100020, 	["name"] = "Brand of Fire", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", ["chance"] = "90" },
								{ ["id"] = 283, 	["name"] = "Ingenuity II", 			["level"] = "50", 	["cost"] = "32", 	["actionType"] = "Buff",		["buffid"] = "256" } },
								
		["Armourer"] = {		{ ["id"] = 100033, 	["name"] = "Rapid Synthesis", 		["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Progress", 	["efficiency"] = "250", 	["chance"] = "50" },
								{ ["id"] = 100036, 	["name"] = "Brand of Ice", 			["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", 	["chance"] = "90" },
								{ ["id"] = 100039, 	["name"] = "Piece By Piece", 		["level"] = "50", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "0", 		["chance"] = "90" } },
								
		["Goldsmith"] = {		{ ["id"] = 278, 	["name"] = "Manipulation", 			["level"] = "15", 	["cost"] = "88", 	["actionType"] = "Buff", 		["buffid"] = "258" },
								{ ["id"] = 100083, 	["name"] = "Flawless Synthesis", 	["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "0", 		["chance"] = "90" },
								{ ["id"] = 284, 	["name"] = "Innovation", 			["level"] = "50", 	["cost"] = "18", 	["actionType"] = "Buff", 		["buffid"] = "259" } },
								
		["Leatherworker"] = {	{ ["id"] = 279, 	["name"] = "Waste Not", 			["level"] = "15", 	["cost"] = "56", 	["actionType"] = "Buff", 		["buffid"] = "252" },
								{ ["id"] = 100050,	["name"] = "Brand Of Earth", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", 	["chance"] = "90" },
								{ ["id"] = 285, 	["name"] = "Waste Not II", 			["level"] = "50", 	["cost"] = "98", 	["actionType"] = "Buff", 		["buffid"] = "257" } },
								
		["Alchemist"] = {		{ ["id"] = 100098, 	["name"] = "Tricks Of The Trade", 	["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Skip" },
								{ ["id"] = 100095, 	["name"] = "Brand of Water", 		["level"] = "37", 	["cost"] = "15", 	["actionType"] = "Progress", 	["efficiency"] = "200", 	["chance"] = "90" },
								{ ["id"] = 286, 	["name"] = "Comfort Zone", 			["level"] = "50", 	["cost"] = "66", 	["actionType"] = "Buff", 		["buffid"] = "261" } },
								
		["Culinary"] = {		{ ["id"] = 100108, 	["name"] = "Hasty Touch", 			["level"] = "15", 	["cost"] = "0", 	["actionType"] = "Quality", 	["efficiency"] = "100", 	["chance"] = "50" },
								{ ["id"] = 281, 	["name"] = "Steady Hand II", 		["level"] = "37", 	["cost"] = "25", 	["actionType"] = "Buff", 		["buffid"] = "262" },
								{ ["id"] = 287, 	["name"] = "Reclaim", 				["level"] = "50", 	["cost"] = "55", 	["actionType"] = "Buff", 		["buffid"] = "260" } }
	}
	return Skills;
end

