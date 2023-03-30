TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- =================================================================================== --

RegisterServerEvent('Armyshop_contract:sellVehicle')
AddEventHandler('Armyshop_contract:sellVehicle', function(target, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _target = target
	local tPlayer = ESX.GetPlayerFromId(_target)local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
			['@identifier'] = xPlayer.identifier,
			['@plate'] = plate
		})
	if result[1] ~= nil then
		MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = plate,
			['@target'] = tPlayer.identifier
		}, function (rowsChanged)
			if rowsChanged ~= 0 then
				TriggerClientEvent('Armyshop_contract:showAnim', _source)
				Wait(22000)
				TriggerClientEvent('Armyshop_contract:showAnim', _target)
				Wait(22000)
				TriggerClientEvent('esx:showNotification', _source, _U('soldvehicle', plate))TriggerClientEvent('esx:showNotification', _target, _U('boughtvehicle', plate))
				xPlayer.removeInventoryItem('contract', 1) -- ชื่อไอเท็ม 
                SetDistcord("Armyshop_givecar 🌐 ","ประวัติการโอนรถ", " คุณ **"  ..xPlayer.name..  "  ** ได้โอนรถไปให้ **  "   ..tPlayer.name..  "   ทะเบียน   " .. plate ..  " ", 0000, Config.webhook)
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('notyourcar'))
	end
end)

ESX.RegisterUsableItem('contract', function(source) -- ชื่อไอเท็ม 
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('Armyshop_contract:getVehicle', _source)
end)

-- =================================================================================== --

function SetDistcord(name,message,description,color,DiscordWebHook)
  
    local embeds = {
           {
                 ["title"]=message,
                 ["type"]="rich",
                 ["color"] =color,
                 ["description"] = description,
                 ["footer"] = {
                 ["text"] = communityname,
                 ["icon_url"] = communtiylogo,
           },
        }
    }
    
if message == nil or message == "Player Log #1" then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
