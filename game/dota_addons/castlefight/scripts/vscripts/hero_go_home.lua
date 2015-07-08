function OnStartTouch(trigger)

	if trigger.activator:GetTeam() == DOTA_TEAM_GOODGUYS then
    	position = Vector(-7715,12,351)
    end
    if trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS then
    	position = Vector(7818,-484,310)
    end

	if trigger.activator:IsHero() then
		trigger.activator:Stop()
		FindClearSpaceForUnit(trigger.activator, position, true)
	end
 
end