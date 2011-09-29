--[[
File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@
]]--
local Proczors = LibStub("AceAddon-3.0"):GetAddon("Proczors")
local L = LibStub("AceLocale-3.0"):GetLocale("Proczors")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local PS = Proczors

--[[ Locals ]]--
local find = string.find
local ipairs = ipairs
local pairs = pairs
local insert = table.insert
local sort = table.sort
local sub = string.sub
local c = select(2, UnitClass("player"))

--[[ Options Table ]]--
options = {
	type="group",
	name = PS.name,
	handler = PS,
	childGroups = "tab",
	args = {
		generalGroup = {
			type = "group",
			name = PS.name,
			args = {
				mainHeader = {
					type = "description",
					name = "  " .. L["PSD"] .. "\n  " .. PS.version .. "\n  " .. sub(PS.date,6,7) .. "-" .. sub(PS.date,9,10) .. "-" .. sub(PS.date,1,4),
					order = 1,
					image = "Interface\\Icons\\Ability_Warrior_Bloodsurge",
					imageWidth = 32, imageHeight = 32,
				},
				turnOn = {
					type = 'toggle',
					order = 2,
					width = "full",
					name = L["turnOn"],
					desc = L["turnOnD"],
					get = function() return PS.db.profile.turnOn end,
					set = function()
						if (not PS.db.profile.turnOn) then
							print("|cFF33FF99Proczors|r: " .. PS.version .. " |cff00ff00Enabled|r")
							PS.db.profile.turnOn = not PS.db.profile.turnOn
						else
							print("|cFF33FF99Proczors|r: " .. PS.version .. " |cffff8080Disabled|r")
							PS.db.profile.turnOn = not PS.db.profile.turnOn
							PS:RefreshRegisters()
						end
					end,
				},
				options = {
					type = "group",
					name = "Options",
					childGroups = "tab",
					disabled = function()
						return not PS.db.profile.turnOn
					end,
					args = {
						main = {
							type = "group",
							name = "Main",
							order = 1,
							disabled = function()
								return not PS.db.profile.turnOn
							end,
							args = {
								optionsHeader = {
									type	= "header",
									order	= 1,
									name	= L["Options"],
								},
								Sound = {
									type = 'toggle',
									order = 2,
									width = "full",
									name = L["Sound"],
									desc = L["SoundD"],
									get = function() return PS.db.profile.Sound end,
									set = function() PS.db.profile.Sound = not PS.db.profile.Sound end,
								},
								LSMSounds = {
									type = 'select',
									order = 3,
									width = "double",
									dialogControl = 'LSM30_Sound',
									name = L["Sound"],
									desc = L["SoundD"],
									values = AceGUIWidgetLSMlists.sound,
									get = function()
										return PS.db.profile.DefSoundName
									end,
									set = function(self,key)
										PS.db.profile.DefSoundName = key
										 PS:RefreshLocals()
									end,
								},
								Msg = {
									type = 'toggle',
									order = 4,
									width = "full",
									name = L["Msg"],
									desc = L["MsgD"],
									get = function() return PS.db.profile.Msg end,
									set = function() PS.db.profile.Msg = not PS.db.profile.Msg end,
								},
								Icon = {
									type = 'toggle',
									order = 5,
									width = "full",
									name = L["Icon"],
									desc = L["IconD"],
									get = function() return PS.db.profile.Icon end,
									set = function() PS.db.profile.Icon = not PS.db.profile.Icon end,
								},
								Flash = {
									type = 'toggle',
									order = 6,
									width = "half",
									name = L["Flash"],
									desc = L["FlashD"],
									get = function() return PS.db.profile.Flash end,
									set = function() PS.db.profile.Flash = not PS.db.profile.Flash end,
								},
								Color = {
									type = 'color',
									hasAlpha = true,
									order = 7,
									disabled = function()
										return not PS.db.profile.Flash
									end,
									width = "half",
									name = L["Color"],
									desc = L["ColorD"],
									get = function()
										local c = PS.db.profile.Color
										return c.r or 1.00, c.g or 0.49, c.b or 0.04, c.a or 0.25
									end,
									set = function(info, r, g, b, a)
										local c = PS.db.profile.Color
										c.r, c.g, c.b, c.a = r, g, b, a
										PS:UpdateColors()
									end,
								},
								Blank0 = {
									type = 'description',
									order = 8,
									width = "full",
									name = "",
								},
								IconSize = {
									type = 'range',
									order = 9,
									disabled = function()
										return not PS.db.profile.Icon
									end,
									min = 25,
									max = 200,
									step = 1.00,
									width = "double",
									name = L["IconSize"],
									desc = L["IconSizeD"],
									get = function(info) return PS.db.profile.IconSize or 75 end,
									set = function(info,v) PS.db.profile.IconSize = v; ProczorsIconFrame:SetWidth(v); ProczorsIconFrame:SetHeight(v); PS:RefreshLocals(); end,
								},
								Blank1 = {
									type = 'description',
									order = 10,
									width = "full",
									name = "",
								},
								IconX = {
									type = 'range',
									order = 11,
									disabled = function()
										return not PS.db.profile.Icon
									end,
									min = -500,
									max = 500,
									step = 10,
									name = L["IconX"],
									desc = L["IconXD"],
									get = function(info) return PS.db.profile.IconLoc.X or 0 end,
									set = function(info,v) PS.db.profile.IconLoc.X = v; PS:RefreshLocals(); end,
								},
								IconY = {
									type = 'range',
									order = 13,
									disabled = function()
										return not PS.db.profile.Icon
									end,
									min = -350,
									max = 350,
									step = 5,
									name = L["IconY"],
									desc = L["IconYD"],
									get = function(info) return PS.db.profile.IconLoc.Y or 50 end,
									set = function(info,v) PS.db.profile.IconLoc.Y = v; PS:RefreshLocals(); end,
								},
								Blank3 = {
									type = 'description',
									order = 14,
									width = "full",
									name = "",
								},
								IconDuration = {
									type = 'range',
									order = 15,
									disabled = function()
										return not PS.db.profile.Icon
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["IconDur"],
									desc = L["IconDurD"],
									get = function(info) return PS.db.profile.IconDura or 2.6 end,
									set = function(info,v) PS.db.profile.IconDura = v; PS:RefreshLocals(); end,
								},
								IconModulation = {
									type = 'range',
									order = 16,
									disabled = function()
										return not PS.db.profile.Icon
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["IconMod"],
									desc = L["IconModD"],
									get = function(info) return PS.db.profile.IconMod or 1.3 end,
									set = function(info,v) PS.db.profile.IconMod = v; PS:RefreshLocals(); end,
								},
								Blank4 = {
									type = 'description',
									order = 17,
									width = "full",
									name = "",
								},
								FlashDuration = {
									type = 'range',
									order = 18,
									disabled = function()
										return not PS.db.profile.Flash
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["FlashDur"],
									desc = L["FlashDurD"],
									get = function(info) return PS.db.profile.FlashDura or 2.6 end,
									set = function(info,v) PS.db.profile.FlashDura = v; PS:RefreshLocals(); end,
								},
								FlashModulation = {
									type = 'range',
									order = 19,
									disabled = function()
										return not PS.db.profile.Flash
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["FlashMod"],
									desc = L["FlashModD"],
									get = function(info) return PS.db.profile.FlashMod or 1.3 end,
									set = function(info,v) PS.db.profile.FlashMod = v; PS:RefreshLocals(); end,
								},
								Blank5 = {
									type = 'description',
									order = 20,
									width = "full",
									name = "",
								},
								IconTest = {
									type = 'execute',
									order = 21,
									disabled = function()
										return not PS.db.profile.Icon
									end,
									width = "double",
									name = L["IconTest"],
									desc = L["IconTestD"],
									func = function() 
										local spellTexture = "Interface\\Icons\\Ability_Warrior_Bloodsurge"
										if (PS.db.profile.Icon) then
											PS:Icon(spellTexture)
										end
										if (PS.db.profile.Sound) then
											PlaySoundFile(PS.SoundFile)
										end
										if (PS.db.profile.Msg) then
											UIErrorsFrame:AddMessage("Test",1,0,0,nil,3)
										end
										if (PS.db.profile.Flash) then
											PS:Flash()
										end
									end,
								},
								Blank6 = {
									type = 'description',
									order = 22,
									width = "full",
									name = "",
								},
								optionsHeader3 = {
									type	= "header",
									order	= 23,
									name	= L["PROC List"],
								},
								SID = {
									type = 'input',
									multiline = 8,
									order = 24,
									width = "double",
									name = L["spellID or spellName"],
									desc = L["Enter spellID or spellName to watch for."],
									usage= L["You can enter either spellID or spellName to search for."],
									get = function(info)
										local a = {}
										local ret = ""
										if (PS.db.profile.SID == nil) then
											PS.db.profile.SID = PS:GetClass(c)
										end
										for _,v in pairs(PS.db.profile.SID) do
											insert(a, v)
										end
										sort(a)
										for _,v in ipairs(a) do
											if ret == "" then
												ret = v
											else
												ret = ret .. "\n" .. v
											end
										end
										return ret
									end,
									set = function(info, value)
										PS:WipeTable(PS.db.profile.SID)
										local tbl = { strsplit("\n", value) }
										for k, v in pairs(tbl) do
											key = "SID"
											PS.db.profile.SID[key..k] = v
										end
									end,
								},
								Blank8 = {
									type = 'description',
									order = 25,
									width = "full",
									name = "",
								},
								Reset_SID = {
									type = 'execute',
									order = 26,
									width = "half",
									name = "Reset",
									desc = "Reset",
									func = function() PS.db.profile.SID = PS:CopyTable(PS:GetClass(c)) end,
								},
							},
						},
						advanced = {
							type = "group",
							name = L["Advanced"],
							order = 2,
							disabled = function()
								return not PS.db.profile.turnOn
							end,
							args = {
								optionsHeader2 = {
									type	= "header",
									order	= 1,
									name	= L["Alternative Combat Log Filtering"],
									desc = L["Default event tracking is via COMBAT_LOG_EVENT"],
								},
								CLEU = {
									type = 'toggle',
									order = 2,
									width = "full",
									name = L["Use COMBAT_LOG_EVENT_UNFILTERED"],
									desc = L["RegCLEUdesc"],
									disabled = function()
										return PS.db.profile.UA
									end,
									get = function() return PS.db.profile.CLEU end,
									set = function() PS.db.profile.CLEU = not PS.db.profile.CLEU; PS:RefreshRegisters(); end,
								},
								UA = {
									type = 'toggle',
									order = 3,
									width = "full",
									name = L["Use UNIT_AURA"],
									desc = L["RegUAdesc"],
									disabled = function()
										return PS.db.profile.CLEU
									end,
									get = function() return PS.db.profile.UA end,
									set = function() PS.db.profile.UA = not PS.db.profile.UA; PS:RefreshRegisters(); end,
								},
								optionsHeader3 = {
									type	= "header",
									order	= 4,
									name	= L["Enable Debugging"],
								},
								Debug = {
									type = 'toggle',
									order = 5,
									width = "full",
									name = L["Enable Debugging"],
									desc = L["Enable Debugging"],
									get = function() return PS.db.profile.debug end,
									set = function() PS.db.profile.debug = not PS.db.profile.debug; end,
								},
								Blank9 = {
									type = 'description',
									order = 6,
									width = "full",
									name = "",
								},
							},
						},
					},
				},
			},
		},
	},
}
