ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('taco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('taco', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = _U('used_taco'), length = 2500, })
end)

ESX.RegisterUsableItem('pretzel', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pretzel', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = _U('used_pretzel'), length = 2500, })
end)

ESX.RegisterUsableItem('hotdog', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hotdog', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = _U('used_hotdog'), length = 2500, })
end)

RegisterServerEvent('esx_foodstand:buyItem')
AddEventHandler('esx_foodstand:buyItem', function(item, amount, price, itemLabel)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    price = ESX.Math.Round(amount * price)

    if xPlayer.getMoney() >= price then
        if xPlayer.canCarryItem(item, amount) then
            xPlayer.addInventoryItem(item, amount)

            xPlayer.removeMoney(price)

            xPlayer.showNotification(_U('bought', amount, itemLabel, ESX.Math.GroupDigits(price)))
        else
            xPlayer.showNotification(_U('not_enough_space'))
        end
    else 
        local missingMoney = price - xPlayer.getMoney()

        xPlayer.showNotification(_U('not_enough_cash', ESX.Math.GroupDigits(missingMoney)))
    end


end)
