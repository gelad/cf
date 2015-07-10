function TriggerCooldown( event )
   event.ability:StartCooldown(event.ability:GetCooldown(event.ability:GetLevel()))
end

function DPrint ( event )
	DebugPrint("[CF] Wolf created")
end

function RallyPointEnemyBase ( event )
	local caster = event.caster
    local target = event.target

    if target:GetTeam() == DOTA_TEAM_GOODGUYS then
    	position = Vector(7818,-484,310)
    end
    if target:GetTeam() == DOTA_TEAM_BADGUYS then
    	position = Vector(-7715,12,351)
    end

    ExecuteOrderFromTable({ UnitIndex = target:GetEntityIndex(), 
                            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE ,
                            Position = position, Queue = true })
end

function RallyPointEnemyBaseUnit ( unit )
	local target = unit

    if target:GetTeam() == DOTA_TEAM_GOODGUYS then
    	position = Vector(7818,-484,310)
    end
    if target:GetTeam() == DOTA_TEAM_BADGUYS then
    	position = Vector(-7715,12,351)
    end

    ExecuteOrderFromTable({ UnitIndex = target:GetEntityIndex(), 
                            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE ,
                            Position = position, Queue = true })
end

function KillBuilding ( event )
	event.caster:ForceKill(false)
end

function ToggleSpawn( event )
	event.target:GetAbilityByIndex(0):ToggleAbility()
end


-- Upgrade building to given type
function UpgradeBuilding ( event )
	local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local player = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
    local position = caster:GetAbsOrigin()
    local ability = event.ability
    
    local unit_ID = ability:GetSpecialValueFor("unit_ID")
    local to_income = ability:GetSpecialValueFor("to_income")
    local to_lumber = 0.0
    to_lumber = ability:GetSpecialValueFor("to_lumber")

    -- NORTHERN
    if unit_ID == 1 then unit_name = "northern_wolf_den"
    elseif unit_ID == 2 then unit_name = "northern_bear_den"
    elseif unit_ID == 11 then unit_name = "northern_ice_mushroom"
    -- HUMAN
    elseif unit_ID == 21 then unit_name = "human_barracks"
    elseif unit_ID == 22 then unit_name = "human_barracks_defender"
    elseif unit_ID == 23 then unit_name = "human_gryphon_shrine"
    end

    
    if to_lumber > 0.0 then
    	player:GiveMana(to_lumber+0.01)
	end

    PlayerResource:AddGoldSpentOnSupport(playerID, to_income)

    for i=0,15 do
    local ability = caster:GetAbilityByIndex(i)
	    if ability then
	    	if ability:IsToggle() then
	    		ability:ToggleAbility()
	    	end 
	    end
  	end

  	local building = CreateUnitByName(unit_name, position, false, nil, nil, caster:GetTeamNumber())
    building:SetOwner(player)
    building:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
    caster:ForceKill(false)
    building:SetAbsOrigin(position)
  	
  	building:GetAbilityByIndex(0):ToggleAbility()
end

-- Add resources, if it's no upgrade ( TODO: make a call from upgrade function?)
function AddToIncomeLumber ( event )
	local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local player = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
    local position = caster:GetAbsOrigin()
    local ability = event.ability
    local to_income = ability:GetSpecialValueFor("to_income")
    local to_lumber = 0.0
    to_lumber = ability:GetSpecialValueFor("to_lumber")

    if to_lumber > 0.0 then
    	player:GiveMana(to_lumber+0.01)
	end
    PlayerResource:AddGoldSpentOnSupport(playerID, to_income)
end

-- Check hero mana for building purpose (lumber)
function CheckHeroMana ( event )
	local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local player = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
    local ability = event.ability

    manacost = ability:GetManaCost(-1)

    if player:GetMana() > manacost then
    	player:SpendMana(manacost, ability)
    	print("manacheck passed")
    else
    	ShowCustomHeaderMessage("dota_hud_error_not_enough_hero_mana", playerID, 1, 5.0)
    	caster:Stop()
	end
end




-- TODO: FROM GREEN TD, CHANGE! (UNUSED YET) ==============================================================================

function check_terrain (entityKeyValues)
	local hero = entityKeyValues.caster
	local ability = entityKeyValues.ability
	position = ability:GetCursorPosition()
	if GridNav:IsNearbyTree(position,500,false) then
		ShowErrorMessage("dota_hud_error_trees",hero)
		hero:Stop()
		return 1
	end
	if position.z >= 129 or position.z <= 127 then
		ShowErrorMessage("dota_hud_error_build_there",hero)
		hero:Stop()
		return 1
	end
	if isNearbyStairs(position) then
		ShowErrorMessage("dota_hud_error_build_stairs",hero)
		hero:Stop()
		return 1
	end
	local unit_radius_good = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, position, nil, 0.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
	local unit_radius_bad = FindUnitsInRadius(DOTA_TEAM_BADGUYS, position, nil, 200.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local unitsColliding = {}
        for k,v in ipairs(unit_radius_good) do unitsColliding[#unitsColliding+1] = v end
	for k,v in ipairs(unit_radius_bad) do unitsColliding[#unitsColliding+1] = v end
	local unit_radius_good = 0
	local unit_radius_bad = 0
	if unitsColliding[1] ~= nil then
		ShowErrorMessage("dota_hud_error_overlapping_towers",hero)
		hero:Stop()
		return 1
	end
	-- Table to safe whether the borders have been reached
	local borderTable = {} 
	-- Table to safe positions pass through
	local posSafe = {} 
	local iposSafe = 0
	--Table initialization
	borderTable[1] = false
	borderTable[2] = false
	--Checkign if the path is blocked
	fromBordertoBorder (position, borderTable, posSafe)
	print(borderTable[1])
	print(borderTable[2])
	if borderTable[1] and borderTable[2] then
		ShowErrorMessage("dota_hud_error_path_block",hero)
		hero:Stop()
		return 1
	end
end