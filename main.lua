local alreadyRegistered = false
Hunterbox_PingCoefficient = 0.400 --Assume about 400ms ping

local function ShowWindow(bool)
    if(bool and InCombatLockdown()) then
        HunterboxGUI:Show()
    else
        HunterboxGUI:Hide()
    end
end

local HunterboxGUI = CreateFrame("Frame", "HunterboxGUI", UIParent) --we dont really want this to be a physical window, its just technical right now

Vulnerable_Create(48)
local VulnerableGUI
local VulnerableCooldownGUI

AimedShot_Create()

local HunterboxCountGUI
local VulnerableCountString
Count_Create()


local function isMarksmanship()
	if (GetSpecialization() == 2) then
        return true
    else
        return false
    end
end

local function isHunter()
    local _, class = UnitClass("player")
    if (class == "HUNTER") then
        return true
    else
        return false
    end
end

local function RegisterifyAddon()
if (isHunter() and isMarksmanship()) then
		if not alreadyRegistered then
			HunterboxGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = true
		end
		ShowWindow(true)
	else
		if alreadyRegistered then
			HunterboxGUI:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = false
		end
		HunterboxGUI:Hide()
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

	-- only if they pass the checks will we actually look at the combat log
	if (isHunter() and isMarksmanship()) then
		HunterboxGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		ShowWindow(true)
		alreadyRegistered = true
	else
		HunterboxGUI:Hide()
	end
	
	-- events to watch to see if they switched to a demo spec
	HunterboxGUI:RegisterEvent("CHARACTER_POINTS_CHANGED")
	HunterboxGUI:RegisterEvent("PLAYER_TALENT_UPDATE")
	HunterboxGUI:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	
	HunterboxGUI:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function HunterboxGUI:COMBAT_LOG_EVENT_UNFILTERED(self, event, ...)  
    if(not InCombatLockdown()) then
        HunterboxGUI:Hide()
    else
        HunterboxGUI:Show()
    end

	local combatEvent = select(1, ...)
	local sourceGUID = select(3, ...)
	local sourceName = select(4, ...)
	local destGUID = select(7, ...)
	local destName = select(8, ...)
    local spellId = select(11, ...)
    local spellName = select(12, ...)
	
    Vulnerable_CombatLog(spellName, destGUID)
    AimedShot_CombatLog(spellName, destGUID)
    Count_CombatLog(...)
end

HunterboxGUI:SetScript("OnEvent", function(self, event, ...)
    self[event](self, event, ...)
end)
HunterboxGUI:RegisterEvent("PLAYER_ENTERING_WORLD")
HunterboxGUI:RegisterEvent("PLAYER_LOGOUT")