function AimedShot_Create()
    print("AimedShot Module Loaded")
    local AimedShotGUI = CreateFrame("Frame", "AimedShotGUI", UIParent)
    AimedShotGUI:SetWidth(48)
    AimedShotGUI:SetHeight(24)
    AimedShotGUI:SetPoint("CENTER", UIParent, -200, -64)
    AimedShotGUI:SetMovable(true)
    return AimedShotGUI
end

function Create_Cooldown(InputGUI, yLocation, TimeLeft, percentDamage)
    InputGUI = CreateFrame("Frame", "AimedShotCooldownGUI", AimedShotGUI)
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
    InputGUI:SetPoint("CENTER", AimedShotGUI, 0, yLocation)

    local CooldownPinwheelGUI = CreateFrame("Cooldown", "AimedShotCooldownGUI", InputGUI, "CooldownFrameTemplate")
    CooldownPinwheelGUI:SetWidth(32)
    CooldownPinwheelGUI:SetHeight(32)
    CooldownPinwheelGUI:SetPoint("CENTER", 0, 0)
    CooldownPinwheelGUI:Show()
    CooldownPinwheelGUI:SetAllPoints()
    
    local DamageIncreaseString = InputGUI:CreateFontString("DamageIncreaseString")
    DamageIncreaseString:SetFont("Interface\\AddOns\\Warlockbox\\Eggo.ttf", 24, "OUTLINE")
    DamageIncreaseString:SetTextColor(1, 1, 1, 1)
    DamageIncreaseString:SetText(percentDamage.."%")
    DamageIncreaseString:SetJustifyH("LEFT")
    DamageIncreaseString:SetJustifyV("CENTER")
    DamageIncreaseString:SetPoint("RIGHT", InputGUI, -32, 0)
    
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
            local AmountOfAimedShots = floor( (VulnerableLength - GlobalCooldown) / AimedShotLength + Hunterbox_PingCoefficient);
            AimedShotMiniGUIs = {}
            for i = 1, AmountOfAimedShots do
                local TimerLength = expirationTime - GetTime() - AimedShotLength - Hunterbox_PingCoefficient
                if(160 - ((i-1)*AmountOfAimedShots*10) > 100) then
                    local CooldownGUI = Create_Cooldown(AimedShotGUI, (i - 1) * 32, TimerLength - ( (i-1) * AimedShotLength + Hunterbox_PingCoefficient), 160 - ((i-1)*AmountOfAimedShots*10) )
                    table.insert(AimedShotMiniGUIs, CooldownGUI)
                end
            end
        end
    end
end