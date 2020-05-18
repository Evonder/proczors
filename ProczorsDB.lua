--[[
File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@
]]--

local Proczors = Proczors or LibStub("AceAddon-3.0"):GetAddon("Proczors")
local L = LibStub("AceLocale-3.0"):GetLocale("Proczors")
local PS = Proczors

function PS:FixWowAceSubnamespaces(db)
	if (db == "DEATHKNIGHT") then
		DEATHKNIGHT = {
			["FILTER1"] = L["DEATHKNIGHT/FILTER1"],
			["FILTER2"] = L["DEATHKNIGHT/FILTER2"],
		}
        PS.db.profile.SID =  DEATHKNIGHT
    elseif (db == "DRUID") then
        DRUID =  {
            ["FILTER1"] = L["DRUID/FILTER1"],
            ["FILTER2"] = L["DRUID/FILTER2"],
            ["FILTER3"] = L["DRUID/FILTER3"],
            ["FILTER4"] = L["DRUID/FILTER4"],
            ["FILTER5"] = L["DRUID/FILTER5"],
        }
        PS.db.profile.SID =  DRUID
    elseif (db == "HUNTER") then
        HUNTER =  {
            ["FILTER1"] = L["HUNTER/FILTER1"],
            ["FILTER2"] = L["HUNTER/FILTER2"],
        }
        PS.db.profile.SID =  HUNTER
    elseif (db == "MAGE") then
        MAGE =  {
            ["FILTER1"] = L["MAGE/FILTER1"],
            ["FILTER2"] = L["MAGE/FILTER2"],
            ["FILTER3"] = L["MAGE/FILTER3"],
            ["FILTER4"] = L["MAGE/FILTER4"],
            ["FILTER5"] = L["MAGE/FILTER5"],
            ["FILTER6"] = L["MAGE/FILTER6"],
        }
        PS.db.profile.SID =  MAGE
    elseif (db == "PALADIN") then
        PALADIN =  {
            ["FILTER1"] = L["PALADIN/FILTER1"],
            ["FILTER2"] = L["PALADIN/FILTER2"],
            ["FILTER3"] = L["PALADIN/FILTER3"],
        }
        PS.db.profile.SID =  PALADIN
    elseif (db == "DRUID") then
        DRUID =  {
            ["FILTER1"] = L["DRUID/FILTER1"],
            ["FILTER2"] = L["DRUID/FILTER2"],
            ["FILTER3"] = L["DRUID/FILTER3"],
            ["FILTER4"] = L["DRUID/FILTER4"],
            ["FILTER5"] = L["DRUID/FILTER5"],
        }
        PS.db.profile.SID =  DRUID
    elseif (db == "PRIEST") then
        PRIEST =  {
            ["FILTER1"] = L["PRIEST/FILTER1"],
            ["FILTER2"] = L["PRIEST/FILTER2"],
            ["FILTER3"] = L["PRIEST/FILTER3"],
        }
        PS.db.profile.SID = PRIEST
    elseif (db == "ROGUE") then
        ROGUE =  {
            ["FILTER1"] = L["ROGUE/FILTER1"],
        }
        PS.db.profile.SID =  ROGUE
    elseif (db == "SHAMAN") then
        DRUID =  {
            ["FILTER1"] = L["SHAMAN/FILTER1"],
            ["FILTER2"] = L["SHAMAN/FILTER2"],
            ["FILTER3"] = L["SHAMAN/FILTER3"],
        }
        PS.db.profile.SID =  SHAMAN
    elseif (db == "WARLOCK") then
        WARLOCK =  {
            ["FILTER1"] = L["WARLOCK/FILTER1"],
            ["FILTER2"] = L["WARLOCK/FILTER2"],
            ["FILTER3"] = L["WARLOCK/FILTER3"],
            ["FILTER4"] = L["WARLOCK/FILTER4"],
            ["FILTER5"] = L["WARLOCK/FILTER5"],
            ["FILTER6"] = L["WARLOCK/FILTER6"],
        }
        PS.db.profile.SID =  WARLOCK
    elseif (db == "WARRIOR") then
        WARRIOR =  {
            ["FILTER1"] = L["WARRIOR/FILTER1"],
            ["FILTER2"] = L["WARRIOR/FILTER2"],
        }
        PS.db.profile.SID =  WARRIOR
	end
end