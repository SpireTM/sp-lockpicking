ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- register item to using
ESX.RegisterUsableItem('lockpick', function(source)
	TriggerClientEvent('lockpicking:startlockpicking', source)
end)

-- remove item from inventory
RegisterNetEvent('lockpicking:removeitem')
AddEventHandler('lockpicking:removeitem', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('lockpick', 1)
end)
