function OnStartTouch(trigger)

	if trigger.activator:GetTeam() == DOTA_TEAM_GOODGUYS then
    	position = Vector(-6404,756,772)
    end
    if trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS then
    	position = Vector(7176,421,649)
    end

	if trigger.activator:IsHero() then
		trigger.activator:Stop()
		trigger.activator:MoveToPosition(position)
	end
 
end
 
function OnEndTouch(trigger)

	if trigger.activator:GetTeam() == DOTA_TEAM_GOODGUYS then
    	position = Vector(-6404,756,772)
    end
    if trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS then
    	position = Vector(7176,421,649)
    end

	if trigger.activator:IsHero() then
		trigger.activator:Stop()
		trigger.activator:MoveToPosition(position)
	end
 
end