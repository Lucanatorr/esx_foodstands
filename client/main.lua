ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
    if Config.UseNPC then

        for k,v in pairs(Config.ShopLocations) do
            RequestModel(Config.NPC)
            while not HasModelLoaded(Config.NPC) do
                Wait(1)
            end
        
            npc = CreatePed(1, Config.NPC, v.x, v.y, v.z - 1, v.h, false, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            SetPedDiesWhenInjured(npc, false)
            SetPedCanPlayAmbientAnims(npc, true)
            SetPedCanRagdollFromPlayerImpact(npc, false)
            SetEntityInvincible(npc, true)
            FreezeEntityPosition(npc, true)
            TaskStartScenarioInPlace(npc, "PROP_HUMAN_BBQ", 0, true);
        end
    end

    if Config.UseBlips then
        for k,v in pairs(Config.ShopLocations) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)

            SetBlipSprite (blip, Config.BlipType.Blip.Sprite)
		    SetBlipDisplay(blip, Config.BlipType.Blip.Display)
		    SetBlipScale  (blip, Config.BlipType.Blip.Scale)
		    SetBlipColour (blip, Config.BlipType.Blip.Color)
		    SetBlipAsShortRange(blip, true)

		    BeginTextCommandSetBlipName('STRING')
		    AddTextComponentSubstringPlayerName(_U('blip_name'))
            EndTextCommandSetBlipName(blip)
        end
    end
end)

local object_model = -1581502570 ----Change to whatever
Citizen.CreateThread(function()
    for k,v in pairs(Config.PropStandLocations) do
        RequestModel(object_model)

        local request = 1
        
        while not HasModelLoaded(object_model) and request < 5 do
    	    Citizen.Wait(500)				
            request = request + 1
        end
    
        if not HasModelLoaded(object_model) then
    	    SetModelAsNoLongerNeeded(object_model)
        else
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
            local created_object = CreateObjectNoOffset(object_model, v.x, v.y, v.z - 1, 1, 0, 1)
            
            SetEntityHeading(created_object, v.h)
            --PlaceObjectOnGroundProperly(created_object)
            FreezeEntityPosition(created_object,true)
            SetModelAsNoLongerNeeded(object_model)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
    
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for k,v in pairs(Config.ShopLocations) do
            local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)

            if distance <= Config.DrawDistance then

                DrawMarker(Config.Marker.Type, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)

                if distance <= 2.0 then
                    ESX.ShowHelpNotification(_U('help_text'))

                    if IsControlJustReleased(0, 51) then
                        OpenShopMenu()
                    end
                end
            end
        end
    end
end)

function OpenShopMenu()

    local elements = {}
    local menuOpen = true

	for k,v in pairs(Config.Items) do
        local item = v.item
        local label = v.label
        local price = v.price

		table.insert(elements, {
			label      = ('%s - <span style="color:green;">%s</span>'):format(label, _U('shop_item', ESX.Math.GroupDigits(price))),
			itemLabel = label,
			item       = item,
			price      = price,

			-- menu properties
			value      = 1,
			type       = 'slider',
			min        = 1,
			max        = 50
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'food_shop', {
        title    = _U('shop_title'),
        align    = 'right',
        elements = elements
    }, function(data, menu)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('shop_confirm', data.current.value, data.current.itemLabel, ESX.Math.GroupDigits(data.current.price * data.current.value)),
			align    = 'right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
		}}, function(data2, menu2)
            if data2.current.value == 'yes' then
                TriggerServerEvent('esx_foodstand:buyItem', data.current.item, data.current.value, data.current.price, data.current.itemLabel)
            else
                menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
        menu.close()
    end)
end
