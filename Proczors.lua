--[[
Proczors
	Instant PROC Notification

File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@

* Copyright (c) 2008, Erik Vonderscheer
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY @file-author@ ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL @file-author@ BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUPSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

Proczors = LibStub("AceAddon-3.0"):NewAddon("Proczors", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Proczors")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local MSQ = LibStub("Masque", true)
local PS = Proczors

--[[ Locals ]]--
local AddonName = "Proczors"
local find = string.find
local ipairs = ipairs
local pairs = pairs
local insert = table.insert
local len = string.len
local sort = table.sort
local sub = string.sub
local c = select(2, UnitClass("player"))
local tocVersion = select(4, GetBuildInfo())

local MAJOR_VERSION = GetAddOnMetadata("Proczors", "Version")
if (len(MAJOR_VERSION)<=8) then
	PS.version = sub(MAJOR_VERSION, 0, 8)
else
	PS.version = MAJOR_VERSION .. " DEV"
end
PS.date = GetAddOnMetadata("Proczors", "X-Date")

defaults = {
	profile = {
		turnOn = true,
		firstlogin = true,
		Sound = true,
		Flash = true,
		Icon = true,
		UnlockIcon = false,
		IconSize = 75,
		IconLoc = {
			X = 0,
			Y = 50,
		},
    IconDura = 2.6,
    IconMod = 1.3,
    FlashDura = 2.6,
    FlashMod = 1.3,
		Msg = false,
		Color = {},
		DefSoundName = "Chimes",
		DefSound = [[Interface\AddOns\]]..AddonName..[[\sounds\Chime.ogg]],
		Skins = {
			SkinID = "Blizzard",
			Gloss = false,
			Backdrop = false,
			Colors = {},
		},
	},
}

function PS:OnInitialize()
	local ACD = LibStub("AceConfigDialog-3.0")
	local LAP = LibStub("LibAboutPanel")

	self.db = LibStub("AceDB-3.0"):New("ProczorsDB", defaults)

	local ACP = LibStub("AceDBOptions-3.0"):GetOptionsTable(Proczors.db)
	
	local AC = LibStub("AceConsole-3.0")
	AC:RegisterChatCommand("ps", function() PS:OpenOptions() end)
	AC:RegisterChatCommand("Proczors", function() PS:OpenOptions() end)
	
	local ACfg = LibStub("AceConfig-3.0")
	ACfg:RegisterOptionsTable("Proczors", PS:getOptions())

	-- Set up options panels.
	self.OptionsPanel = ACD:AddToBlizOptions(self.name, self.name, nil, "generalGroup")
	self.OptionsPanel.about = LAP.new(self.name, self.name)
	
	if (LSM) then
		-- Chime.ogg used from Prat 3.0
		LSM:Register("sound", "Chimes",[[Interface\AddOns\]]..AddonName..[[\sounds\Chime.ogg]])
		PS.SoundFile = LSM:Fetch("sound", PS.db.profile.DefSoundName)
	end
	
	if (IsLoggedIn()) then
		self:IsLoggedIn()
	else
		self:RegisterEvent("PLAYER_LOGIN", "IsLoggedIn")
	end
end

-- :OpenOptions(): Opens the options window.
function PS:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
end

function PS:IsLoggedIn()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "Proczors")
	PS:RefreshLocals()
	PS:LoadMSQ()
	if (PS.db.profile.firstlogin) then
		PS.db.profile.SID = PS:GetClass(c)
		PS.db.profile.firstlogin = false
	end
	self:UnregisterEvent("PLAYER_LOGIN")
end

--[[ Helper Functions ]]--
function PS:GetClass(c)
	if (c == "DEATHKNIGHT") then return L.DEATHKNIGHT end
	if (c == "DRUID") then return L.DRUID end
	if (c == "HUNTER") then return L.HUNTER end
	if (c == "MAGE") then return L.MAGE end
	if (c == "PALADIN") then return L.PALADIN end
	if (c == "PRIEST") then return L.PRIEST end
	if (c == "ROGUE") then return L.ROGUE end
	if (c == "SHAMAN") then return L.SHAMAN end
	if (c == "WARLOCK") then return L.WARLOCK end
	if (c == "WARRIOR") then return L.WARRIOR end
end

function PS:WipeTable(t)
	if (t ~= nil and type(t) == "table") then
		wipe(t)
	end
end

function PS:CopyTable(t)
  local new_t = {}
  for k, v in pairs(t) do
    if (type(v) == "table") then
      new_t[k] = PS:CopyTable(v)
    else
			new_t[k] = v
    end
  end
  return new_t
end

function PS:PrintIt(txt)
	print(txt)
end

function PS:UpdateColors()
	local c = PS.db.profile.Color
	for k, v in ipairs(c) do
		v:SetVertexColor(c.r or 1.00, c.g or 0.49, c.b or 0.04, (c.a or 0.25) * (v.alphaFactor or 1) / PS:GetAlpha())
	end
	PS:RefreshLocals()
end

function PS:RefreshLocals()
	self.IconFrame = nil
	self.FlashFrame = nil
	PS.SoundFile = LSM:Fetch("sound", PS.db.profile.DefSoundName) or PS.db.profile.DefSound
  IconSize = PS.db.profile.IconSize
  IconX = PS.db.profile.IconLoc.X
  IconY = PS.db.profile.IconLoc.Y
  IconDura = PS.db.profile.IconDura
  IconMod = PS.db.profile.IconMod
  FlashDura = PS.db.profile.FlashDura
  FlashMod = PS.db.profile.FlashMod
	if (PS.db.profile.debug) then
		PS:PrintIt("Proczors: Icon Information: " .. IconSize .. " - " .. IconX .. " - " .. IconY .. " - " .. IconDura .. " - " .. FlashDura .. " - " .. IconMod .. " - " .. FlashMod)
	end
end

--[[ LibButtonFacade ]]--
function PS:LoadMSQ()
	if MSQ then
		local group = MSQ:Group("Proczors", "Icon")
		
		group.SkinID = PS.db.profile.Skins.SkinID
		group.Backdrop = PS.db.profile.Skins.Backdrop
		group.Gloss = PS.db.profile.Skins.Gloss
		group.Colors = PS.db.profile.Skins.Colors or {}
		
		MSQ:Register("Proczors", PS.SkinChanged, self)
		
		MSQGroup = group
	end
end

function PS:SkinChanged(SkinID, Gloss, Backdrop, Group, Button, Colors)
	PS.db.profile.Skins.SkinID = SkinID
	PS.db.profile.Skins.Gloss = Gloss
	PS.db.profile.Skins.Backdrop = Backdrop
	PS.db.profile.Skins.Colors = Colors
end

--[[ Icon Func ]]--
function PS:Icon(spellTexture)
	if (spellTexture and spellTexture ~= savedTexture or not self.IconFrame) then
		local icon = CreateFrame("Button", "ProczorsIconFrame")
		icon:SetFrameStrata("BACKGROUND")
		icon:SetWidth(IconSize)
		icon:SetHeight(IconSize)
		icon:EnableMouse(false)
		icon:Hide()
		icon.texture = icon:CreateTexture(nil, "BACKGROUND")
		icon.texture:SetAllPoints(icon)
		icon.texture:SetTexture(spellTexture)
		icon:ClearAllPoints()
		icon:SetPoint("CENTER", PS.db.profile.IconLoc.X, PS.db.profile.IconLoc.Y) 
		icon.texture:SetBlendMode("ADD")
		icon:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		icon:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < IconDura then
				local alpha = elapsed % IconMod
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.IconFrame = icon
		if (MSQGroup and icon) then
			MSQGroup:AddButton(icon)
		end
	end
	self.IconFrame:Show()
	local savedTexture = spellTexture
end

--[[ Flash Func - Taken from Omen ]]--
function PS:Flash()
	if not self.FlashFrame then
		local c = PS.db.profile.Color
		local flasher = CreateFrame("Frame", "ProczorsFlashFrame")
		flasher:SetToplevel(true)
		flasher:SetFrameStrata("FULLSCREEN_DIALOG")
		flasher:SetAllPoints(UIParent)
		flasher:EnableMouse(false)
		flasher:Hide()
		flasher.texture = flasher:CreateTexture(nil, "BACKGROUND")
		flasher.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < FlashDura then
				local alpha = elapsed % FlashMod
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.FlashFrame = flasher
	end

	self.FlashFrame:Show()
end

--[[ Registered Event ]]--
function PS:Proczors(event, ...)
	if (PS.db.profile.debug) then
		PS:PrintIt("Proczors: We have an event!")
	end
	if (event == "COMBAT_LOG_EVENT" or "COMBAT_LOG_EVENT_UNFILTERED") then
		if (PS.db.profile.debug) then
			PS:PrintIt("Proczors: COMBAT_LOG_EVENT or COMBAT_LOG_EVENT_UNFILTERED")
		end
		local timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = select(1, ...)
		PS:SpellWarn(combatEvent, sourceName, spellId, spellName)
	end
end

function PS:SpellWarn(combatEvent, sourceName, spellId, spellName)
	if (PS.db.profile.turnOn and combatEvent ~= "SPELL_AURA_REMOVED" and combatEvent ~= "SPELL_AURA_REFRESHED" and combatEvent == "SPELL_AURA_APPLIED" and sourceName == UnitName("player")) then
		for k,v in pairs(PS.db.profile.SID) do
			if (spellId == nil or spellName == nil) then
				return
			elseif (find(spellId,v) or find(spellName,v)) then
				local name,_,spellTexture = GetSpellInfo(spellId or spellName)
				if (PS.db.profile.Sound) then
					PlaySoundFile(PS.SoundFile, "SFX")
				end
				if (PS.db.profile.Flash) then
					PS:Flash()
				end
				if (PS.db.profile.Icon) then
					PS:Icon(spellTexture)
				end
				if (PS.db.profile.Msg) then
					UIErrorsFrame:AddMessage(name,1,0,0,nil,3)
				end
			end
		end
	end
end	
