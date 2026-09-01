RegisterNetEvent('no-melee-instakill:applyDamage', function(damage)
    local ped = PlayerPedId()

    if IsEntityDead(ped) then
        return
    end

    local health = GetEntityHealth(ped)
    local newHealth = health - damage

    -- Player ped health uses 100 as the effective zero-health baseline.
    -- Allow repeated melee hits to eventually kill normally.
    if newHealth <= 100 then
        SetEntityHealth(ped, 0)
        return
    end

    SetEntityHealth(ped, newHealth)
end)
