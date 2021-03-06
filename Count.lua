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
    VulnerableCountString:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    VulnerableCountString:SetTextColor(1, 1, 1, 1)
    VulnerableCountString:SetText("")
    VulnerableCountString:SetJustifyH("CENTER")
    VulnerableCountString:SetJustifyV("CENTER")
    VulnerableCountString:SetPoint("RIGHT", HunterboxCountGUI, -10, -2)
end

function Count_CombatLog(...)
    local combatEvent = select(1, ...)
	local sourceGUID = select(3, ...)
    local spellId = select(11, ...)
    
    if(combatEvent == "SPELL_AURA_APPLIED" and spellId == 187131 and sourceGUID == UnitGUID("Player")) then --Vulnerable: 187131
        local VulnerableLength = 7
        VulnerableCount = VulnerableCount + 1
        C_Timer.After(VulnerableLength, function() 
            VulnerableCount = VulnerableCount - 1
            VulnerableCountString:SetText(VulnerableCount)
        end)
        VulnerableCountString:SetText(VulnerableCount)
    end
end