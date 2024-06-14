ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

RequestAnimDict("mp_arresting")
while (not HasAnimDictLoaded("mp_arresting")) do 
    Citizen.Wait(0) 
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
            local lock = GetVehicleDoorLockStatus(veh)
            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
            local pedd = GetPedInVehicleSeat(veh, -1)
            if pedd then
                SetPedCanBeDraggedOut(pedd, false)
            end
        end
    end
end)

RegisterNetEvent('lockpicking:startlockpicking')
AddEventHandler('lockpicking:startlockpicking', function()
    local ped = PlayerPedId()
    local pedc = GetEntityCoords(ped)
    local closeveh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 5.0, 0 ,71)
    local lockstatus = GetVehicleDoorLockStatus(closeveh)
    local distance = #(GetEntityCoords(closeveh) - pedc)
    if distance < 3 then
        if lockstatus == 2 then
            TaskPlayAnim(ped,"mp_arresting","a_uncuff", 8.0, -8, -1, 49, 0, 0, 0, 0)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
            FreezeEntityPosition(PlayerPedId(), true)
            TriggerServerEvent('lockpicking:removeitem')
            local finished = exports["taskbarskill"]:taskBar(3700, 1)
            if finished == 100 then
                progbar()
                Citizen.Wait(10000)
                lockpick()
            else
                lockpickfail()
            end
        else
            exports['mythic_notify']:DoHudText('inform', 'Vehicle is not locked')
        end
    else
        exports['mythic_notify']:DoHudText('inform', 'No vehicle nearby')
    end
end)

function lockpick()
    ped = PlayerPedId()
    pedc = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 3.0, 0, 71)
    FreezeEntityPosition(PlayerPedId(), false)
    exports['mythic_notify']:DoHudText('inform', 'Vehicle unlocked')
    SetVehicleDoorsLocked(veh, 0)
    SetVehicleDoorsLockedForAllPlayers(veh, false)
    ClearPedTasks(PlayerPedId())
end

function lockpickfail()
    ped = PlayerPedId()
    pedc = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 3.0, 0, 71)
    exports['mythic_notify']:DoHudText('inform', 'Lockpick broke, the vehicle alarms went off')
    FreezeEntityPosition(PlayerPedId(), false)
    SetVehicleAlarm(veh, true)
    SetVehicleAlarmTimeLeft(veh, 4000)
    SetVehicleDoorsLocked(veh, 2)
    ClearPedTasks(PlayerPedId())
end

function progbar()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = 10000,
        label = "Lockpicking...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(status)
    end)
end
