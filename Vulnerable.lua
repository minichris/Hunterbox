function Vulnerable_Create(Size)
    print("Vulnerable Module Loaded")
    local VulnerableGUI = CreateFrame("Frame", "VulnerableGUI", UIParent)
    VulnerableGUI:SetBackdrop({
        bgFile = "Interface\\Icons\\ability_hunter_mastermarksman",
        edgeFile = "Interface\\tooltips\\UI-tooltip-Border",
        tile = true,
        tileSize = Size,
        edgeSize = 8,
        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1,
        },
    })
    VulnerableGUI:SetWidth(Size)
    VulnerableGUI:SetHeight(Size)
    VulnerableGUI:SetPoint("CENTER", 50, 50)
    VulnerableGUI:SetMovable(true)

    local VulnerableCooldownGUI = CreateFrame("Cooldown", "VulnerableCooldownGUI", VulnerableGUI, "CooldownFrameTemplate")
    VulnerableCooldownGUI:SetAllPoints()
    VulnerableCooldownGUI:SetWidth(Size)
    VulnerableCooldownGUI:SetHeight(Size)
    VulnerableCooldownGUI:SetPoint("CENTER", 0, 0)
    VulnerableCooldownGUI:Hide()
    VulnerableCooldownGUI:SetHideCountdownNumbers(true)
    VulnerableCooldownGUI:SetAllPoints()
    
    local CurrentDamageIncreaseString = VulnerableCooldownGUI:CreateFontString("CurrentDamageIncreaseString")
    CurrentDamageIncreaseString:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    CurrentDamageIncreaseString:SetTextColor(1, 1, 1, 1)
    CurrentDamageIncreaseString:SetText("1")
    CurrentDamageIncreaseString:SetJustifyH("CENTER")
    CurrentDamageIncreaseString:SetJustifyV("CENTER")
    CurrentDamageIncreaseString:SetPoint("CENTER", VulnerableCooldownGUI, -2, -2)
    VulnerableGUI:SetScript("OnUpdate", function(self, elapsed)
        local startTime, duration = VulnerableCooldownGUI:GetCooldownTimes()
        CurrentDamageIncreaseString:SetText((170 - 10*ceil((startTime + duration)/1000 - GetTime())).."%")
    end)
    
    return VulnerableGUI
end

function Vulnerable_CombatLog(spellName, destGUID)
    local Debuff = UnitDebuff("target", "Vulnerable");
    local expirationTime = select(7,UnitDebuff("target","Vulnerable"))
    if(UnitDebuff("target", "Vulnerable") ~= nil) then
        VulnerableGUI:Show()
        if( (spellName == "Marked Shot" or spellName == "Windburst") and destGUID == UnitGUID("target")) then
            VulnerableCooldownGUI:SetCooldown(GetTime(), expirationTime - GetTime())
        end
    else
        VulnerableGUI:Hide()
    end
end