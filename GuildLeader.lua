local GUI = LibStub("AceGUI-3.0")

--Options Interface--
local options = { 
	name = function(info)
			return "GuildLeader v1.0.3 By: Impurity"
			end,
    handler = GuildLeader,
    type = 'group',
    childGroups = "tab",
    args = {
		gmheader = {
			type = 'header',
			name = function(info)
			if GuildLeader:GetGuildName()~=nil then
			return strjoin("","Settings for ",GuildLeader.db:GetCurrentProfile())
			else
			return "Guild Leader is disabled as you are not currently in a guild"
			end
			end,
			order = 1,
			},
		recruitment = {
			type = 'group',
			name = "Recruitment",
			desc = "Guild Recruitment Settings",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 2,
			args = {
			zonerecruitment = {
			type = 'group',
			name = "Zone Recruitment",
			desc = "Zone Recruitment Settings",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 1,
			args = {
				cityspam = {
			type = 'toggle',
			name = "CitySpam Enabled?",
			desc = "Should I spam in cities?",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			get = function(info)
						return GuildLeader.db.profile.cityspam
					end,
			set = function(info, newValue)
						GuildLeader.db.profile.cityspam = newValue
					end,
			order = 1,
		},
				zonespam = {
				type = 'toggle',
				name = "ZoneSpam Enabled?",
				desc = "Should I spam in regular zones?",
				disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildLeader.db.profile.zonespam
						end,
				set = function(info, newValue)
							GuildLeader.db.profile.zonespam = newValue
						end,
				order = 2,
			},
				outpvpspam = {
				type = 'toggle',
				name = "Outdoor PVP Zones Enabled?",
				desc = "Should I spam in outdoor pvp zones?",
				disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildLeader.db.profile.outpvpspam
						end,
				set = function(info, newValue)
							GuildLeader.db.profile.outpvpspam = newValue
						end,
				order = 3,
			},
				interval = {
			type = 'range',
			name = "Interval",
			desc = "The amount of minutes between messages in a particular location",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			min = 1,
			max = 120,
			step = 1,			
			get = function(info)
						return GuildLeader.db.profile.between
					end,
			set = function(info, newValue)
						GuildLeader.db.profile.between = newValue
					end,
			order = 4,
		},
				lastspam = {
					type = 'execute',
					name = "Last time spammed in zone",
					desc = "Spit out to chat the last time someone in this guild has spammed in this zone",
					func = 	function(info)
							local currentzone
							if (GuildLeader:IsCity()) then
								currentzone = "City"
							else
                                currentzone = GetZoneText()
                            end
							GuildLeader:Print(string.format("The last time spammed in this zone was %s minutes ago", tostring(tonumber(GuildLeader:GetTime()) - (tonumber(GuildLeader.db.profile.lasttime[currentzone]) or 0))))
						end,
			order = 5,
		},
				manspam = {
					type = 'execute',
					name = "Manual Spam",
					desc = "Spams current zone",
					disabled = function(info)
					if IsGuildLeader()~=true then 
					return true
					else
					return false
					end
					end,
					func = 	function(info)
					if (GuildLeader:IsCity()) then 
					GuildLeader:SpamZone("City")
					else
					GuildLeader:SpamZone(GetZoneText())
					end
					end,
			order = 6,
		},
				msg = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "General Chat Message",
            desc = "The message text that will be broadcast in General/Trade",
            usage = "<Your message here>",
            disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
            get = function(info)
						return GuildLeader.db.profile.message
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.message = newValue
					end,
			order = 7,
        },
				citychannel = {
			type = 'range',
			name = "City Channel Number",
			desc = "Lets you choose which channel number you would like to recruit on while in a city. NOTE: By default 1 will use General, 2 will use Trade but it varies depending on how you set up your chat channels.",
			min = 1,
			max = 10,
			step = 1,
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,			
			get = function(info)
						return GuildLeader.db.profile.citychannel
					end,
			set = function(info, newValue)
						GuildLeader.db.profile.citychannel = newValue
					end,
			order = 8,
		},
				zonechannel = {
			type = 'range',
			name = "Zone Channel Number",
			desc = "Lets you choose which channel number you would like to recruit on while in a general zone. NOTE: By default 1 will use General, 3 will use Local Defense but it varies depending on how you set up your chat channels.",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			min = 1,
			max = 10,
			step = 1,			
			get = function(info)
						return GuildLeader.db.profile.zonechannel
					end,
			set = function(info, newValue)
						GuildLeader.db.profile.zonechannel = newValue
					end,
			order = 9,
		},
				},
			},
			newmembers = {
			type = 'group',
			childGroups = "tab",
			name = "New Members",
			desc = "Events for new guild members joining.",
			disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
			order = 2,
			args = {
			welcomeannounce = {
					type = "select",
					order = 3,
					name = "Announce New Members",
					desc = "Choose to announce when a member is added to the guild",
					disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
					values = {"None","Officer","Guild"},
					get = function(info)
						return GuildLeader.db.profile.welcomeannounce
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.welcomeannounce = newValue
							end,
					},
			sendwhisper = {
			type = 'toggle',
				name = "Whisper on join",
				desc = "Send the message below to new members that join the guild.",
				disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
				get = function(info)
							return GuildLeader.db.profile.sendwhisper
						end,
				set = function(info, newValue)
							GuildLeader.db.profile.sendwhisper = newValue
						end,
				order = 1,
			},
			welcomewhisp = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Guild Welcome Whisper",
            desc = "The message text that will be sent to the new guild member. If you don't want to send a whisper, leave blank.",
            usage = "<Your message here>",
            disabled = function(info)
				if CanGuildInvite()~=true then 
				return true
				else
				return false
				end
				end,
            get = function(info)
						return GuildLeader.db.profile.welcomewhisp
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.welcomewhisp = newValue
					end,
			order = 2,
        },
			},
			},
			}
			},
		announcements = {
			type = 'group',
			name = "Announcements",
			desc = "Guild Announcement Settings",
			order = 3,
			args = {
			annoucementstats= {
					type = 'execute',
					name = "Announcement Stats",
					desc = "Prints which message was spammed last and when it was spammed.",
					func = 	function()
					if ValidMessages==1 then
					GuildLeader:Print(strjoin(" ","A Guild Announcement was made",(GuildLeader:GetTime()-GuildLeader.db.profile.lastanntime),"minutes ago. Guild Announcement",GuildLeader.db.profile.announcenext,"is due to print in",(GuildLeader.db.profile.lastanntime+GuildLeader.db.profile.nextannouncetime)-GuildLeader:GetTime(),"minutes."))
					else
					GuildLeader:Print("There Are No Valid Messages!")
					end
							end,
			order = 1,
		},
				annoucementskip= {
					type = 'execute',
					name = "Skip Announcement",
					desc = "Skips the next upcoming announcement and loads the one after that.",
					func = 	function()
					if ValidMessages==1 then
					GuildLeader:Print(strjoin(" ","Skipping Guild Announcement",GuildLeader.db.profile.announcenext))
					announcementskip=1
					GuildLeader:LoadNextAnnouncement()
					announcementskip=0
					GuildLeader:Print(strjoin(" ","Guild Announcement",GuildLeader.db.profile.announcenext,"Loaded"))
					else 
					GuildLeader:Print("There Are No Valid Messages!")
					end
					end,
			order = 2,
		},
				announcmentoverride = {
					type = 'execute',
					name = "Announce Now",
					desc = "Overrides the timer and broadcasts the next upcoming announcement.",
					func = 	function()
					if ValidMessages==1 then
					GuildLeader:ExecuteAnnouncement()
					else
					GuildLeader:Print("There Are No Valid Messages!")
					end
					end,
			order = 3,
		},
				announcement1 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 1",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildLeader.db.profile.announcement1
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.announcement1 = newValue
					end,
			order = 4,
        },
				announcementtimer1 = {
					type = 'range',
					name = "Announcement 1 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildLeader.db.profile.announcementtimer1
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementtimer1 = newValue
							end,
					order = 5,
				},
				announcementto1 = {
					type = "select",
					order = 6,
					name = "Announce to Officer/Guild 1",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildLeader.db.profile.announcementto1
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementto1 = newValue
							end,
					},
				announcementborder1 = {
					type = "select",
					order = 7,
					name = "Announce Border 1",
					desc = "Border style to wrap around the announcement. Great for announcements that exceed the single message character limit.",
					values = {"None","Star","Circle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildLeader.db.profile.announcementborder1
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementborder1 = newValue
							end,
					},
				announcement2 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 2",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildLeader.db.profile.announcement2
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.announcement2 = newValue
					end,
			order = 8,
        },
				announcementtimer2 = {
					type = 'range',
					name = "Announcement 2 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildLeader.db.profile.announcementtimer2
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementtimer2 = newValue
							end,
					order = 9,
				},
				announcementto2 = {
					type = "select",
					order = 10,
					name = "Announce to Officer/Guild 2",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildLeader.db.profile.announcementto2
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementto2 = newValue
							end,
					},
				announcementborder2 = {
					type = "select",
					order = 11,
					name = "Announce Border 2",
					desc = "Border style to wrap around the announcement. Great for announcements that exceed the single message character limit.",
					values = {"None","Star","Circle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildLeader.db.profile.announcementborder2
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementborder2 = newValue
							end,
					},
				announcement3 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 3",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildLeader.db.profile.announcement3
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.announcement3 = newValue
					end,
			order = 12,
        },
				announcementtimer3 = {
					type = 'range',
					name = "Announcement 3 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildLeader.db.profile.announcementtimer3
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementtimer3 = newValue
							end,
					order = 13,
				},
				announcementto3 = {
					type = "select",
					order = 14,
					name = "Announce to Officer/Guild 3",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildLeader.db.profile.announcementto3
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementto3 = newValue
							end,
					},
				announcementborder3 = {
					type = "select",
					order = 15,
					name = "Announce Border 3",
					desc = "Border style to wrap around the announcement. Great for announcements that exceed the single message character limit.",
					values = {"None","Star","Circle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildLeader.db.profile.announcementborder3
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementborder3 = newValue
							end,
					},
				announcement4 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 4",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildLeader.db.profile.announcement4
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.announcement4 = newValue
					end,
			order = 16,
        },
				announcementtimer4 = {
					type = 'range',
					name = "Announcement 4 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildLeader.db.profile.announcementtimer4
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementtimer4 = newValue
							end,
					order = 17,
				},
				announcementto4 = {
					type = "select",
					order = 18,
					name = "Announce to Officer/Guild 4",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildLeader.db.profile.announcementto4
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementto4 = newValue
							end,
					},
				announcementborder4 = {
					type = "select",
					order = 19,
					name = "Announce Border 4",
					desc = "Border style to wrap around the announcement. Great for announcements that exceed the single message character limit.",
					values = {"None","Star","Circle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildLeader.db.profile.announcementborder4
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementborder4 = newValue
							end,
					},
				announcement5 = {
            type = 'input',
            multiline = true,
            width = "full",
            name = "Announcement 5",
            desc = "The message text that will be broadcast in Guild/Officer",
            usage = "<Your message here>",
            get = function(info)
						return GuildLeader.db.profile.announcement5
					end,
            set = function(info, newValue)
						GuildLeader.db.profile.announcement5 = newValue
					end,
			order = 20,
        },
				announcementtimer5 = {
					type = 'range',
					name = "Announcement 5 Timer",
					desc = "Set the amount of time between the PREVIOUS message and THIS message.",
					min = 1,
					max = 60,
					step = 1,
					get = function(info)
						return GuildLeader.db.profile.announcementtimer5
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementtimer5 = newValue
							end,
					order = 21,
				},
				announcementto5 = {
					type = "select",
					order = 22,
					name = "Announce to Officer/Guild 5",
					desc = "Choose which channel to make this announcement in OR disable it.",
					values = {"Disabled","Officer","Guild"},
					get = function(info)
						return GuildLeader.db.profile.announcementto5
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementto5 = newValue
							end,
					},
				announcementborder5 = {
					type = "select",
					order = 23,
					name = "Announce Border 5",
					desc = "Border style to wrap around the announcement. Great for announcements that exceed the single message character limit.",
					values = {"None","Star","Circle","Diamond","Triangle","Moon","Square","Cross","Skull"},
					get = function(info)
						return GuildLeader.db.profile.announcementborder5
							end,
					set = function(info, newValue)
							GuildLeader.db.profile.announcementborder5 = newValue
							end,
					},

		},
				
		}
		},
	}

local function ChatCmd(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(GuildLeader.optionsframe)
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(GuildLeader, "gl", "GuildLeader", input:trim() ~= "help" and input or "")
	end
end

GuildLeader = LibStub("AceAddon-3.0"):NewAddon("GuildLeader", "AceTimer-3.0", "AceEvent-3.0", "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceHook-3.0")
GuildLeader:RegisterChatCommand("GuildLeader", ChatCmd)
GuildLeader:RegisterChatCommand("gl", ChatCmd)

local function SetLayout(this)
  dewdrop:Close()
  if not t1 then
    t1 = this:CreateFontString(nil, "ARTWORK")
    t1:SetFontObject(GameFontNormalLarge)
    t1:SetJustifyH("LEFT") 
    t1:SetJustifyV("TOP")
    t1:SetPoint("TOPLEFT", 16, -16)
    t1:SetText(this.name)


    local t2 = this:CreateFontString(nil, "ARTWORK")
    t2:SetFontObject(GameFontHighlightSmall)
    t2:SetJustifyH("LEFT") 
    t2:SetJustifyV("TOP")
    t2:SetHeight(43)
    t2:SetPoint("TOPLEFT", t1, "BOTTOMLEFT", 0, -8)
    t2:SetPoint("RIGHT", this, "RIGHT", -32, 0)
    t2:SetNonSpaceWrap(true)
    local function GetInfo(field)
      return GetAddOnMetadata(this.addon, field) or "N/A"
    end
    t2:SetFormattedText("Notes: %s\nAuthor: %s\nVersion: %s\nRevision: %s", GetInfo("Notes"), GetInfo("Author"), GetInfo("Version"), GetInfo("X-Build"))

    local b = CreateFrame("Button", nil, this, "UIPanelButtonTemplate")
    b:SetWidth(120)
    b:SetHeight(20)
    b:SetText("Options Menu")
    b:SetScript("OnClick", GuildLeader.DewOptions)
    b:SetPoint("TOPLEFT", t2, "BOTTOMLEFT", -2, -8)
  end
end

function GuildLeader:DewOptions()
	dewdrop:Open('dummy', 'children', function() dewdrop:FeedAceOptionsTable(options) end, 'cursorX', true, 'cursorY', true)
end

local function CreateUIOptionsFrame(addon) 
  local panel = CreateFrame("Frame")
  panel.name = GetAddOnMetadata(addon, "Title") or addon
  panel.addon = addon
  panel:SetScript("OnShow", SetLayout)
  InterfaceOptions_AddCategory(panel)
end

function GuildLeader:ToggleActive(state)
	active = state
end

--Setup functions--
function GuildLeader:GetGuildName()
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player")
	return guildName
 end

function GuildLeader:OnInitialize()
	GuildRoster()
	GuildNameTest=GuildLeader:GetGuildName()
    GuildLeader.db = LibStub("AceDB-3.0"):New("GuildLeaderDB", {}, "Default")
    GuildLeader.db:RegisterDefaults({
        profile = {
            lasttime = {},
            guild = "",
			active = true,
			cityspam = false,
			zonespam = false,
			outpvpspam = false,
			between = 3,
			message = "",
			citychannel = 2,
			zonechannel = 1,
			whispmessage = "",
			sendwhisper = false,
			membercap = 1000,
			welcomeannounce = 1,
			welcomewhisp = "",
			announcement1 = "",
			announcementtimer1 = 60,
			announcementto1 = 1,
			announcementborder1 = 1,
			announcement2 = "",
			announcementtimer2 = 60,
			announcementto2 = 1,
			announcementborder2 = 1,
			announcement3 = "",
			announcementtimer3 = 60,
			announcementto3 = 1,
			announcementborder3 = 1,
			announcement4 = "",
			announcementtimer4 = 60,
			announcementto4 = 1,
			announcementborder4 = 1,
			announcement5 = "",
			announcementtimer5 = 60,
			announcementto5 = 1,
			announcementborder5 = 1,
			nextannouncemessage = "",
			nextannouncetime = 0,
			nextannouncechannel = 1,
			nextannounceborder = 1,
			lastannounced = 0,
			announcenext = 0,
			lastanntime = 0,
			CurrentGuildLeader = "",
        },
    })
	if not GuildLeader.version then GuildLeader.version = tonumber(GetAddOnMetadata("GuildLeader", "X-Build")) end
    GuildLeader.optionsframe = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GuildLeader", "Guild Leader")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GuildLeader", options)
	if (GuildLeader.db.profile.version ~= GuildLeader.version) then 
		GuildLeader.db.profile.lasttime = {}
		GuildLeader.db.profile.version = GuildLeader.version
	end		
	active = GuildLeader.db.profile.active
end

function GuildLeader:OnEnable()
	GuildRoster()
	if GuildLeader:GetGuildName()~=nil then
	GuildLeader.db:SetProfile(strjoin("","<",GuildLeader:GetGuildName(),">"," of ",GetRealmName()))
	else
	GuildLeader.db:SetProfile("Default")
	end
	if GuildLeader:GetGuildName() == nil then
		GuildLeader:ScheduleTimer("OnEnable", .1)
		return
	end
	GuildLeader:TurnSelfOn()
end

function GuildLeader:TurnSelfOn()
	GuildLeader:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	GuildLeader:ScheduleRepeatingTimer("MasterTimer", 30)
	GuildLeader:Print("Loaded and Fully Operational! Type /GL to manage your options.")
end



--Automation Functions--
function GuildLeader:GetTime()
	local hours,minutes = GetGameTime()
	local caldate = C_Calendar.GetDate()
	local m = caldate.month
	local d = caldate.monthDay
	local y = caldate.year
	return ((d + math.floor( ( 153*m - 457 ) / 5 ) + 365*y + math.floor( y / 4 ) - math.floor( y / 100 ) + math.floor( y / 400 ) + 1721118.5) * 1440) +(hours*60)+(minutes)
end

function GuildLeader:MasterTimer()
GuildLeader:ScheduleTimer("RunAnnouncemnts", 10)
GuildLeader:ScheduleTimer("CheckZone", 15)
if GuildLeader.db.profile.automatewho==true and (WhoCycle==0 or WhoCycle==nil) and GetNumGuildMembers()<=999 and GuildLeader.db.profile.membercap>GetNumGuildMembers() then
GuildLeader:ScheduleTimer("RunWhoSearch", 20)
end
end

--Registered Event Functions--
local GMframe = CreateFrame("FRAME", "GuildLeader");
GMframe:RegisterEvent("CHAT_MSG_SYSTEM");
GMframe:RegisterEvent("ADDON_LOADED");
local function GMWelcome(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" then 
		local msg = ...;
		local PlayerName, PlayerRealm = UnitName("Player")
		if (msg and msg ~= nil) then
			if ((string.find(msg, "has joined the guild") ~= nil)) then
				starts, ends = string.find(msg," ")
				args1 = string.sub(msg, 0, starts-1)
				if (args1 ~= UnitName("player"))then
				if GuildLeader.db.profile.welcomeannounce==3 then
				SendChatMessage(strjoin(" ","Please welcome our newest member",args1), "GUILD", nil, arg2);
				end
				if GuildLeader.db.profile.welcomeannounce==2 then
				SendChatMessage(strjoin(" ","Please welcome our newest member",args1), "OFFICER", nil, arg2);
				end
				if GuildLeader.db.profile.sendwhisper==true then
				SendChatMessage(GuildLeader.db.profile.welcomewhisp,"WHISPER",nil,args1) 
				end
				end
				end
			if ((string.find(msg, strjoin("",PlayerName," has joined the guild"))==1)) then
				GuildLeader.db:SetProfile(strjoin("","<",GuildLeader:GetGuildName(),">"," of ",GetRealmName()))
				GuildLeader:RegisterMyToons()
				end
			if ((string.find(msg, strjoin("",PlayerName," has left the guild"))==1)) or ((string.find(msg, strjoin("",PlayerName," has been kicked out of the guild by"))==1)) then
				GuildLeader.db:SetProfile("Default")
				end
				--You have invited xxxx to join your guild.
				--123456789012345678  123456789012345678901
			if ((string.find(msg, "You have invited") ~= nil)) and ((string.find(msg, "to join your guild.") ~= nil)) then
				args1 = string.sub(msg, 18, -21)
				if (args1 ~= UnitName("player"))then
				if GuildLeader.db.profile.sendwhisper==true then
				SendChatMessage(GuildLeader.db.profile.whispmessage,"WHISPER",nil,args1)
				end
				end
				end
			end
		end	
	end	
GMframe:SetScript("OnEvent", GMWelcome);

--Zone Recruitment Functions--
function GuildLeader:CHAT_MSG_CHANNEL_NOTICE(what, a, b, c, d, e, f, number, channel)
GuildLeader:ScheduleTimer("CheckZone", 5)
end
function GuildLeader:CheckZone()
if GetNumGuildMembers()<=999 and GuildLeader.db.profile.membercap>GetNumGuildMembers() then
local inInstance, instanceType = IsInInstance()
if inInstance==false then
if (GuildLeader:IsCity())==true then
GMzone="City"
elseif (GuildLeader:IsCity())~=true then
GMzone=(GetZoneText())
end
end
if GMzone=="City" and GuildLeader.db.profile.cityspam==true then
GuildLeader:CheckTime(GMzone)
end
if GMzone~="City" and GuildLeader.db.profile.zonespam==true then
if GetZonePVPInfo()~="combat" then
GuildLeader:CheckTime(GMzone)
end
if GetZonePVPInfo()=="Combat" and GuildLeader.db.profile.outpvpspam==true then
GuildLeader:CheckTime(GMzone)
end
end
end
end

--Check if player is in City --
function GuildLeader:IsCity()
isCityZone=(GetZoneText())  
cityCheck = {"Stormwind City", "Darnassus", "City of Ironforge", "The Exodar", "Shrine of Seven Stars", "Stormshield", "Lunarfall", "Orgrimmar", "Thunder Bluff", "Undercity", "Silvermoon City", "Shrine of Two Moons", "Warspear", "Frostwall", "Dalaran", "Shattrath City", "Dazar'alor", "Boralus Harbor"}
  for index = 1, #cityCheck do
        if cityCheck[index] == isCityZone then
        return true
      end
      
      return false
        end
  end
    

function GuildLeader:CheckTime(GMzone)
if GMzone==nil then
	if (GuildLeader:IsCity())==true then
	GMzone="City"
	elseif (GuildLeader:IsCity())~=true then
	GMzone=(GetZoneText())
	end
end
if GuildLeader.db.profile.lasttime[GMzone]==nil then 
GuildLeader.db.profile.lasttime[GMzone]=0
end 
timediffspam=(GuildLeader:GetTime())-GuildLeader.db.profile.lasttime[GMzone]
if timediffspam>=GuildLeader.db.profile.between then
GuildLeader:SpamZone(GMzone)
end
end
 
function GuildLeader:SpamZone(GMzone)
if GMzone=="City" then 
number=GuildLeader.db.profile.citychannel
else 
number=GuildLeader.db.profile.zonechannel
end
SendChatMessage(GuildLeader.db.profile.message,"CHANNEL",nil,number)

GuildLeader.db.profile.lasttime[GMzone]=GuildLeader:GetTime() 
end

--*ANNOUNCEMENTS*--
function GuildLeader:RunAnnouncemnts()
if AnnouncementsActivated~=1 and ValidMessages~=1 then--Announcements
GuildLeader:AnnouncementsActivate()
else
GuildLeader:NextAnnouncementValid()
end
end
--Load & Reload Functions--
function GuildLeader:AnnouncementsActivate()
GuildLeader:AnnouncementsFindValid()
if (GuildLeader.db.profile.lastannounced==0 or GuildLeader.db.profile.announcenext==0) and ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
GuildLeader:AnnouncementsActivate()
elseif (GuildLeader.db.profile.lastannounced==0 or GuildLeader.db.profile.announcenext==0) and ValidMessages==0 then
AnnouncementsActivated=0
else
end
if GuildLeader.db.profile.lastannounced~=0 and GuildLeader.db.profile.announcenext~=0 and ValidMessages==1 then
AnnouncementsActivated=1
GuildLeader:NextAnnouncementValid()
else
AnnouncementsActivated=0
end
end

function GuildLeader:NextAnnouncementValid()
if GuildLeader.db.profile.announcenext==1 then
if GuildLeader.db.profile.announcement1~="" and (GuildLeader.db.profile.announcementto1==2 or GuildLeader.db.profile.announcementto1==3) then
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement1
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer1
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto1
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder1
GuildLeader:CheckTimeAnnouncement()
else
GuildLeader:AnnouncementsFindValid()
if ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildLeader.db.profile.announcenext==2 then 
if GuildLeader.db.profile.announcement2~="" and (GuildLeader.db.profile.announcementto2==2 or GuildLeader.db.profile.announcementto2==3) then
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement2
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer2
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto2
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder2
GuildLeader:CheckTimeAnnouncement()
else
GuildLeader:AnnouncementsFindValid()
if ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildLeader.db.profile.announcenext==3 then
if GuildLeader.db.profile.announcement3~="" and (GuildLeader.db.profile.announcementto3==2 or GuildLeader.db.profile.announcementto3==3) then
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement3
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer3
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto3
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder3
GuildLeader:CheckTimeAnnouncement()
else
GuildLeader:AnnouncementsFindValid()
if ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildLeader.db.profile.announcenext==4 then
if GuildLeader.db.profile.announcement4~="" and (GuildLeader.db.profile.announcementto4==2 or GuildLeader.db.profile.announcementto4==3) then
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement4
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer4
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto4
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder4
GuildLeader:CheckTimeAnnouncement()
else
GuildLeader:AnnouncementsFindValid()
if ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
if GuildLeader.db.profile.announcenext==5 then
if GuildLeader.db.profile.announcement5~="" and (GuildLeader.db.profile.announcementto5==2 or GuildLeader.db.profile.announcementto5==3) then
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement5
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer5
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto5
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder5
GuildLeader:CheckTimeAnnouncement()
else
GuildLeader:AnnouncementsFindValid()
if ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
else
AnnouncementsActivated=0
end
end
end
end

function GuildLeader:AnnouncementsFindValid()
if GuildLeader.db.profile.announcement1~="" and (GuildLeader.db.profile.announcementto1==2 or GuildLeader.db.profile.announcementto1==3) then
Announcement1Valid=1
else
Announcement1Valid=0
end
if GuildLeader.db.profile.announcement2~="" and (GuildLeader.db.profile.announcementto2==2 or GuildLeader.db.profile.announcementto2==3) then
Announcement2Valid=1
else
Announcement2Valid=0
end
if GuildLeader.db.profile.announcement3~="" and (GuildLeader.db.profile.announcementto3==2 or GuildLeader.db.profile.announcementto3==3) then
Announcement3Valid=1
else
Announcement3Valid=0
end
if GuildLeader.db.profile.announcement4~="" and (GuildLeader.db.profile.announcementto4==2 or GuildLeader.db.profile.announcementto4==3) then
Announcement4Valid=1
else
Announcement4Valid=0
end
if GuildLeader.db.profile.announcement5~="" and (GuildLeader.db.profile.announcementto5==2 or GuildLeader.db.profile.announcementto5==3) then
Announcement5Valid=1
else
Announcement5Valid=0
end
if Announcement1Valid==0 and Announcement2Valid==0 and Announcement3Valid==0 and Announcement4Valid==0 and Announcement5Valid==0 then 
ValidMessages=0
else
ValidMessages=1
end
end

function GuildLeader:DetermineNextAnnouncement()
reachedendofcheck=0
GuildLeader:AnnouncementsFindValid()
if GuildLeader.db.profile.lastannounced==5 and Announcement1Valid==1 then
GuildLeader.db.profile.announcenext=1
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement1
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer1
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto1
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder1
elseif GuildLeader.db.profile.lastannounced==5 and Announcement1Valid==0 then
GuildLeader.db.profile.lastannounced=1
end
if GuildLeader.db.profile.lastannounced==1 and Announcement2Valid==1 then
GuildLeader.db.profile.announcenext=2
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement2
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer2
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto2
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder2
elseif GuildLeader.db.profile.lastannounced==1 and Announcement2Valid==0 then
GuildLeader.db.profile.lastannounced=2
end
if GuildLeader.db.profile.lastannounced==2 and Announcement3Valid==1 then
GuildLeader.db.profile.announcenext=3
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement3
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer3
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto3
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder3
elseif GuildLeader.db.profile.lastannounced==2 and Announcement3Valid==0 then
GuildLeader.db.profile.lastannounced=3
end
if GuildLeader.db.profile.lastannounced==3 and Announcement4Valid==1 then
GuildLeader.db.profile.announcenext=4
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement4
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer4
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto4
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder4
elseif GuildLeader.db.profile.lastannounced==3 and Announcement4Valid==0 then
GuildLeader.db.profile.lastannounced=4
end
if GuildLeader.db.profile.lastannounced==4 and Announcement5Valid==1 then
GuildLeader.db.profile.announcenext=5
GuildLeader.db.profile.nextannouncemessage=GuildLeader.db.profile.announcement5
GuildLeader.db.profile.nextannouncetime=GuildLeader.db.profile.announcementtimer5
GuildLeader.db.profile.nextannouncechannel=GuildLeader.db.profile.announcementto5
GuildLeader.db.profile.nextannounceborder=GuildLeader.db.profile.announcementborder5
elseif GuildLeader.db.profile.lastannounced==4 and Announcement5Valid==0 then
GuildLeader.db.profile.lastannounced=5
reachedendofcheck=1
if GuildLeader.db.profile.lastannounced==5 and reachedendofcheck==1 and ValidMessages==1 then
GuildLeader:DetermineNextAnnouncement()
end
end
end

--Timer Functions--
function GuildLeader:CheckTimeAnnouncement()
if GuildLeader.db.profile.lastanntime==nil then 
GuildLeader.db.profile.lastanntime=0 
end
lastanndiff=GuildLeader:GetTime()-GuildLeader.db.profile.lastanntime
if lastanndiff>=GuildLeader.db.profile.nextannouncetime then
GuildLeader:ExecuteAnnouncement()
elseif lastanndiff<GuildLeader.db.profile.nextannouncetime then
end
end

--Format Functions--
function GuildLeader:PrintBorder()
if GuildLeader.db.profile.nextannouncechannel==2 then
borderchannel="officer"
bordertarget="OFFICER"
elseif GuildLeader.db.profile.nextannouncechannel==3 then
borderchannel="guild"
bordertarget="GUILD"
end
if GuildLeader.db.profile.nextannouncechannel==2 or GuildLeader.db.profile.nextannouncechannel==3 then
if GuildLeader.db.profile.nextannounceborder==2 then
SendChatMessage("{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}{Star}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==3 then
SendChatMessage("{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}{Circle}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==4 then
SendChatMessage("{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}{Diamond}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==5 then
SendChatMessage("{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}{Triangle}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==6 then
SendChatMessage("{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}{Moon}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==7 then
SendChatMessage("{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}{Square}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==8 then
SendChatMessage("{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}{X}",borderchannel, nil,bordertarget)
end
if GuildLeader.db.profile.nextannounceborder==9 then
SendChatMessage("{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}{Skull}",borderchannel, nil,bordertarget)
end
end
end

function GuildLeader:PrintAnnouncement()
nextannvar=GuildLeader.db.profile.nextannouncemessage
if GuildLeader.db.profile.nextannouncechannel==2 then
annchannel="officer"
anntarget="OFFICER"
elseif GuildLeader.db.profile.nextannouncechannel==3 then
annchannel="guild"
anntarget="GUILD"
end
local message, pattern, position;
position = 1;
for i = 1, #nextannvar, 255 do
message = nextannvar:sub(position, position + 254);
if #message < 255 then
pattern = ".+";
else
pattern = "(.+)%s";
end
for capture in message:gmatch(pattern) do
SendChatMessage(capture,annchannel, nil,anntarget)
position = position + #capture + 1;
end
end
end

--Execution Functions--
function GuildLeader:ExecuteAnnouncement()
GuildLeader:PrintBorder()
GuildLeader:PrintAnnouncement()
GuildLeader:PrintBorder()
GuildLeader:LoadNextAnnouncement()
end

function GuildLeader:LoadNextAnnouncement()
if announcementskip~=1 then
GuildLeader.db.profile.lastanntime=GuildLeader:GetTime()
end
GuildLeader.db.profile.lastannounced=GuildLeader.db.profile.announcenext
if GuildLeader.db.profile.lastannounced==5 then 
nextinline=1
else
nextinline=GuildLeader.db.profile.lastannounced+1
end
GuildLeader.db.profile.announcenext=nextinline
GuildLeader:NextAnnouncementValid()
end