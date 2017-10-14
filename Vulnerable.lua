-- Patient Sniper talent data
local PatientSniperDamageBonusPercent = 0; --the amount Patient Sniper increases the damage bonus of Vulnerable every 1 sec
local VulnerableDamageBonusPercent = 130; --the amount of damage increased by regular Vulnerable

local function HasPatientSniper() --check if player hads the Patient Sniper talent
	_, _, _, selected = GetTalentInfo(4, 3, 1);
	
	if selected then
		PatientSniperDamageBonusPercent = 6;
	else
		PatientSniperDamageBonusPercent = 0;
	end
	
	return selected;
end

function Vulnerable_Create(Size)
    print("Vulnerable Module Loaded")
	HasPatientSniper();
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
    VulnerableCooldownGUI:SetHideCountdownNumbers(true)
    VulnerableCooldownGUI:SetAllPoints()
	VulnerableCooldownGUI:Show()
    
    local CurrentDamageIncreaseString = VulnerableCooldownGUI:CreateFontString("CurrentDamageIncreaseString")
    CurrentDamageIncreaseString:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    CurrentDamageIncreaseString:SetTextColor(1, 1, 1, 1)
    CurrentDamageIncreaseString:SetJustifyH("CENTER")
    CurrentDamageIncreaseString:SetJustifyV("CENTER")
    CurrentDamageIncreaseString:SetPoint("CENTER", VulnerableCooldownGUI, -2, -2)
    VulnerableGUI:SetScript("OnUpdate", function(self, elapsed)
        local startTime, duration = VulnerableCooldownGUI:GetCooldownTimes();
        CurrentDamageIncreaseString:SetText(VulnerableDamageBonusPercent + (PatientSniperDamageBonusPercent * (7 - ceil((startTime + duration)/1000 - GetTime()))) .. "%" );
		if(UnitDebuff("target", "Vulnerable") ~= nil) then
			VulnerableGUI:Show();
		else
			VulnerableGUI:Hide();
		end
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