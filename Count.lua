VulnerableCount = 0

function Count_Create()
    print("Vulnerable Count Module Loaded")
    
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
            print(VulnerableCount)
        end)
        print(VulnerableCount)
    end
end