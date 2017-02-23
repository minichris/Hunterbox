function AimedShot_Create()
    print("AimedShot Module Loaded")
    
    
end

function Create_Cooldown(InputGUI, yLocation, TimeLeft)
    InputGUI = CreateFrame("Frame", "AimedShotGUI", UIParent)
    InputGUI:SetBackdrop({
        bgFile = "Interface\\Icons\\Inv_spear_07",
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
    InputGUI:SetWidth(32)
    InputGUI:SetHeight(32)
    InputGUI:SetPoint("CENTER", -50, yLocation)

    CooldownPinwheelGUI = CreateFrame("Cooldown", "AimedShotCooldownGUI", InputGUI, "CooldownFrameTemplate")
    CooldownPinwheelGUI:SetWidth(32)
    CooldownPinwheelGUI:SetHeight(32)
    CooldownPinwheelGUI:SetPoint("CENTER", 0, 0)
    CooldownPinwheelGUI:Show()
    CooldownPinwheelGUI:SetAllPoints()
    
    C_Timer.After(TimeLeft, function() 
        InputGUI:Hide() 
    end)
    
    CooldownPinwheelGUI:SetCooldown(GetTime(), TimeLeft)
    
    return CooldownPinwheelGUI
end

function AimedShot_CombatLog(spellName, destGUID)
    local GlobalCooldown = 1;
    local VulnerableLength = 7 --hard coded for now
    local AimedShotLength = select(4,GetSpellInfo("Aimed Shot"))/1000
    local expirationTime = select(7, UnitDebuff("target", "Vulnerable"))
    if(UnitDebuff("target", "Vulnerable") ~= nil) then --if the target has Vulnerable
        if( (spellName == "Marked Shot" or spellName == "Windburst") and destGUID == UnitGUID("target") ) then --if it is newly appiled
            for i = 1, floor( (VulnerableLength - GlobalCooldown) / AimedShotLength) do
                local TimerLength = expirationTime - GetTime() - AimedShotLength - Hunterbox_PingCoefficient
                CooldownGUI = Create_Cooldown(AimedShotGUI, i * 32 - 50, TimerLength - ( (i-1) * AimedShotLength + Hunterbox_PingCoefficient))
            end
        end
    end
end