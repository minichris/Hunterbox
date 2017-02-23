function Vulnerable_Create()
    print("Vulnerable Module Loaded")
    VulnerableGUI = CreateFrame("Frame", "VulnerableGUI", GUI)
    VulnerableGUI:SetBackdrop({
        bgFile = "Interface\\Icons\\ability_hunter_mastermarksman",
        edgeFile = "Interface\\tooltips\\UI-tooltip-Border",
        tile = true,
        tileSize = 64,
        edgeSize = 8,
        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1,
        },
    })
    VulnerableGUI:SetWidth(64)
    VulnerableGUI:SetHeight(64)
    VulnerableGUI:SetPoint("CENTER", 50, 50)

    VulnerableCooldownGUI = CreateFrame("Cooldown", "VulnerableCooldownGUI", VulnerableGUI, "CooldownFrameTemplate")
    VulnerableCooldownGUI:SetAllPoints()
    VulnerableCooldownGUI:SetWidth(64)
    VulnerableCooldownGUI:SetHeight(64)
    VulnerableCooldownGUI:SetPoint("CENTER", 0, 0)
    VulnerableCooldownGUI:Show()
    VulnerableCooldownGUI:SetAllPoints()
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