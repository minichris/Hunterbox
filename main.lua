local alreadyRegistered = false
local HunterBox_Unlocked = false
local DebugMode = false
Hunterbox_PingCoefficient = 0.500 --Assume about 400ms ping

local function isMarksmanship()
	local _, class = UnitClass("player")
    if (class == "HUNTER" and GetSpecialization() == 2) then
		return true
	else
		return false
	end
end

local function ShowWindow(bool)
    if(bool and InCombatLockdown() and isMarksmanship()) then
        HunterboxGUI:Show()
    else
        HunterboxGUI:Hide()
    end
end

local HunterboxGUI = CreateFrame("Frame", "HunterboxGUI", UIParent) --we dont really want this to be a physical window, its just technical right now
ShowWindow(false) --don't show the window before its needed
local VulnerableGUI = Vulnerable_Create(48)

local AimedShotMiniGUIs = {}
local AimedShotGUI = AimedShot_Create()

local HunterboxCountGUI
local VulnerableCountString
Count_Create()

local function RegisterifyAddon()
if (isMarksmanship()) then
		if not alreadyRegistered then
			HunterboxGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = true
		end
	else
		if alreadyRegistered then
			HunterboxGUI:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = false
		end
	end
end

-- events
function HunterboxGUI:CHARACTER_POINTS_CHANGED(self, event, ...)
	RegisterifyAddon()
end

function HunterboxGUI:PLAYER_TALENT_UPDATE(self, event, ...)
	RegisterifyAddon()
end

function HunterboxGUI:ACTIVE_TALENT_GROUP_CHANGED(self, event, ...)
	RegisterifyAddon()
end

function HunterboxGUI:PLAYER_ENTERING_WORLD(self, event, ...)
	RegisterifyAddon()	
	-- events to watch to see if they switched spec
	HunterboxGUI:RegisterEvent("CHARACTER_POINTS_CHANGED")
	HunterboxGUI:RegisterEvent("PLAYER_TALENT_UPDATE")
	HunterboxGUI:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	HunterboxGUI:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

-- Combat Log
function HunterboxGUI:COMBAT_LOG_EVENT_UNFILTERED(self, event, ...)  
	local combatEvent = select(1, ...)
	local sourceGUID = select(3, ...)
	local sourceName = select(4, ...)
	local destGUID = select(7, ...)
	local destName = select(8, ...)
    local spellId = select(11, ...)
    local spellName = select(12, ...)
	
    if(not DebugMode) then
        Vulnerable_CombatLog(spellName, destGUID)
        AimedShot_CombatLog(spellName, destGUID)
        Count_CombatLog(...)
    end
end


-- Commands
SlashCmdList['HUNTERBOX_SLASHCMD'] = function(msg)
    if(msg == "lock" or msg == "lt") then
        if (HunterBox_Unlocked) then
            HunterBox_Unlocked = false
            DebugMode = false
            AimedShotGUI:SetBackdrop(nil)
            print("Box is now locked.")
        else 
            HunterBox_Unlocked = true
            for i = 1, 5 do
                CooldownGUI = Create_Cooldown(AimedShotGUI, i * 32, i*7, "debug")
            end
            AimedShotGUI:SetBackdrop({
                bgFile = "Interface\\Icons\\Inr_07",
                edgeFile = "Interface\\tooltips\\UI-tooltip-Border",
                tile = true,
                tileSize = 32,
                edgeSize = 8,
                insets = {
                    left = 1,
                    right = 1,
                    top = 1,
                    bottom = 1,
                },
            })
            DebugMode = true
            VulnerableGUI:Show()
            VulnerableCooldownGUI:SetCooldown(GetTime(), 20)
            print("Box is now unlocked")
        end
        ZapLib_FrameMoveable(HunterBox_Unlocked, VulnerableGUI)
        ZapLib_FrameMoveable(HunterBox_Unlocked, AimedShotGUI)
    end
end
SLASH_HUNTERBOX_SLASHCMD1 = '/hb'
SLASH_HUNTERBOX_SLASHCMD2 = '/hunterbox'

HunterboxGUI:SetScript("OnEvent", function(self, event, ...)
    self[event](self, event, ...)
end)
HunterboxGUI:RegisterEvent("PLAYER_ENTERING_WORLD")
HunterboxGUI:RegisterEvent("PLAYER_LOGOUT")