function GameMode:FilterExecuteOrder( filterTable )
    --[[for k, v in pairs( filterTable ) do
        print("Order: " .. k .. " " .. tostring(v) )
    end]]

    local units = filterTable["units"]
    local order_type = filterTable["order_type"]
    local issuer = filterTable["issuer_player_id_const"]

    print(order_type)

    if order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
        local unit = EntIndexToHScript(units["0"])
        local targetIndex = filterTable["entindex_target"]
        local target = EntIndexToHScript(targetIndex)
        if unit:FindModifierByName("modifier_prevent_attack_flying") and target:HasFlyMovementCapability() then
            return false
        end
    end

    return true
end
