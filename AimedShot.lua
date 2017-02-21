function AimedShot_Create()
    print("AimedShot Module Loaded")
    AimedShotGUI = CreateFrame("Frame", "AimedShotGUI", GUI)
    AimedShotGUI:SetBackdrop({
        bgFile = "Interface\\Icons\\Inv_spear_07",
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
    AimedShotGUI:SetWidth(64)
    AimedShotGUI:SetHeight(64)
    AimedShotGUI:SetPoint("CENTER", -50, 50)

    AimedShotCooldownGUI = CreateFrame("Cooldown", "AimedShotCooldownGUI", AimedShotGUI, "CooldownFrameTemplate")
    AimedShotCooldownGUI:SetAllPoints()
    AimedShotCooldownGUI:SetWidth(64)
    AimedShotCooldownGUI:SetHeight(64)
    AimedShotCooldownGUI:SetPoint("CENTER", 0, 0)
    AimedShotCooldownGUI:Show()
    AimedShotCooldownGUI:SetAllPoints()
end

function AimedShot_CombatLog(spellName, destGUID)
    -- Aimed Shot timer
    local expirationTime = select(7, UnitDebuff("target", "Vulnerable"))
    if(UnitDebuff("target", "Vulnerable") ~= nil) then
        AimedShotGUI:Show()
        if( (spellName == "Marked Shot" or spellName == "Windburst") and destGUID == UnitGUID("target") ) then
            local AimedShotCastTime = select(4,GetSpellInfo("Aimed Shot"))/1000
            AimedShotCooldownGUI:SetCooldown(GetTime(), expirationTime - GetTime() - AimedShotCastTime - Hunterbox_PingCoefficient)
        end
    else
        AimedShotGUI:Hide()
    end
end