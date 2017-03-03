VulnerableCount = 0

function Count_Create()
    print("Vulnerable Count Module Loaded")
    HunterboxCountGUI = CreateFrame("Frame", "HunterboxCountGUI", VulnerableGUI)
    HunterboxCountGUI:SetBackdrop({
        bgFile = "Interface\\dialogframe\\ui-dialogbox-background-dark",
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
    HunterboxCountGUI:SetWidth(70)
    HunterboxCountGUI:SetHeight(30)
    HunterboxCountGUI:SetPoint("RIGHT", VulnerableGUI, 40, 0)
    HunterboxCountGUI:SetFrameStrata("LOW") --stick it behind the vulnerableGUI
    
    VulnerableCountString = HunterboxCountGUI:CreateFontString("VulnerableCountString")
    VulnerableCountString:SetFont("Interface\\AddOns\\Warlockbox\\Eggo.ttf", 24, "OUTLINE")
    VulnerableCountString:SetTextColor(1, 1, 1, 1)
    VulnerableCountString:SetText("")
    VulnerableCountString:SetJustifyH("CENTER")
    VulnerableCountString:SetJustifyV("CENTER")
    VulnerableCountString:SetPoint("RIGHT", HunterboxCountGUI, -10, -2)
end

function Count_CombatLog(...)
    local combatEvent = select(1, ...)
	local sourceGUID = select(3, ...)
	local sourceName = select(4, ...)
	local destGUID = select(7, ...)
	local destName = select(8, ...)
    local spellId = select(11, ...)
    local spellName = select(12, ...)
    
    if(combatEvent == "SPELL_AURA_APPLIED" and spellName == "Vulnerable" and sourceGUID == UnitGUID("Player")) then
        local VulnerableLength = 7
        VulnerableCount = VulnerableCount + 1
        C_Timer.After(VulnerableLength, function() 
            VulnerableCount = VulnerableCount - 1
            VulnerableCountString:SetText(VulnerableCount)
        end)
        VulnerableCountString:SetText(VulnerableCount)
    end
end