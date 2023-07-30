-- Join discord for support:https://discord.gg/BGwrmpjRyQ

Citizen.CreateThread(function()
    local heldEntity = nil
    local distance = 10.0
    local isEPressed = false
    local downForce = vector3(0, 0, -2.0)

    while true do
        Citizen.Wait(0)
        local player = PlayerId()
        local playerPed = GetPlayerPed(-1)
        local weapon = GetSelectedPedWeapon(playerPed)

        if weapon == GetHashKey("WEAPON_PISTOL") and IsPlayerFreeAiming(player) then
            if heldEntity == nil then
                local entity = getEntityPlayerIsAimingAt(player)
                if entity ~= nil and IsControlJustReleased(0, 51) then
                    if not isEPressed then
                        heldEntity = entity
                        isEPressed = true
                        SetEntityHasGravity(heldEntity, false)
                    else
                        isEPressed = false
                    end
                end
            elseif heldEntity ~= nil then
                if IsControlJustPressed(2, 15) then
                    distance = distance + 3.0
                elseif IsControlJustPressed(2, 14) then
                    distance = distance - 3.0
                end
                if IsControlJustReleased(0, 51) then
                    if isEPressed then
                        ApplyForceToEntity(heldEntity, 1, downForce, 0.0, 0.0,
                                           0.0, false, false, true, true, false,
                                           true)
                        SetEntityHasGravity(heldEntity, true)
                        heldEntity = nil
                        isEPressed = false
                    else
                        isEPressed = true
                    end
                else
                    local desiredCoords = getAimCoords(playerPed, distance)
                    SetEntityCoords(heldEntity, desiredCoords.x,
                                    desiredCoords.y, desiredCoords.z)
                end
            end
        else
            if heldEntity ~= nil then
                ApplyForceToEntity(heldEntity, 1, downForce, 0.0, 0.0, 0.0,
                                   false, false, true, true, false, true)
                SetEntityHasGravity(heldEntity, true)
                heldEntity = nil
                isEPressed = false
            end
        end
    end
end)

function getAimCoords(playerPed, distance)
    local rotation = GetGameplayCamRot(2)
    local direction = rotationToDirection(rotation)
    local playerCoord = GetEntityCoords(playerPed)
    local aimCoords = playerCoord + direction * distance
    return aimCoords
end

function rotationToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))

    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

function getEntityPlayerIsAimingAt(player)
    local result, target = GetEntityPlayerIsFreeAimingAt(player)
    if result then
        return target
    else
        return nil
    end
end
