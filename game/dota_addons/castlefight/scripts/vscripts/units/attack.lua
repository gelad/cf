function CheckAttack( event )
	local target = event.target -- The target of the attack
	local attacker = event.attacker

		ExecuteOrderFromTable({ UnitIndex = attacker:GetEntityIndex(), 
									OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET, 
									TargetIndex = target:GetEntityIndex(), 
									Queue = false
								}) 

end