local function getVictimFromDamageEvent(data)
    local netId = data.hitGlobalId

    if (not netId or netId == 0)
        and data.hitGlobalIds
        and data.hitGlobalIds[1]
    then
        netId = data.hitGlobalIds[1]
    end

    if not netId or netId == 0 then
        return nil
    end

    local entity = NetworkGetEntityFromNetworkId(netId)

    if entity == 0 or not DoesEntityExist(entity) then
        return nil
    end

    if GetEntityType(entity) ~= 1 then
        return nil
    end

    local victim = NetworkGetEntityOwner(entity)

    if not victim or victim <= 0 then
        return nil
    end

    return victim
end

AddEventHandler('weaponDamageEvent', function(sender, data)
    if data.damageType ~= Config.MeleeDamageType then
        return
    end

    -- Normal melee hit: leave GTA completely alone.
    if not data.willKill then
        return
    end

    local victim = getVictimFromDamageEvent(data)

    if not victim or victim == sender then
        return
    end

    -- Stop GTA's instant-kill damage.
    CancelEvent()

    -- Replace it with normal controlled melee damage.
    TriggerClientEvent(
        'no-melee-instakill:applyDamage',
        victim,
        Config.ReplacementDamage
    )
end)
