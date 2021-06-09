ESX             = nil
local ShopItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM shops1 LEFT JOIN items ON items.name = shops1.item', {}, function(shopResult)
		for i=1, #shopResult, 1 do
			if shopResult[i].name and Config.Zones[shopResult[i].store] then
				if ShopItems[shopResult[i].store] == nil then
					ShopItems[shopResult[i].store] = {}
				end

				table.insert(ShopItems[shopResult[i].store], {
					label = shopResult[i].label,
					item  = shopResult[i].item,
					price = shopResult[i].price,
				})
			else
				print(('esx_shops: invalid item "%s" found!'):format(shopResult[i].item))
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)
	cb(ShopItems)
end)

RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, amount, zone, type)
	print(zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	amount = ESX.Math.Round(amount)

	-- is the player trying to exploit?
	if amount < 0 then
		print('esx_shops: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''

	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			price = ShopItems[zone][i].price
			itemLabel = ShopItems[zone][i].label
			break
		end
	end

	price = price * amount
	
	if Config.Zones[zone].Weapons then
		if Config.Zones[zone].Blackmoney then
			money = xPlayer.getAccount('black_money').money
		else
			money = xPlayer.getMoney()
		end
		if not xPlayer.hasWeapon(itemName) then
			if money >= price then
				if Config.Zones[zone].Societymoney then
					local societyAccount = nil
					TriggerEvent(
						"esx_addonaccount:getSharedAccount",
						Config.Zones[zone].Societymoney,
						function(account)
							societyAccount = account
						end)
						societyAccount.addMoney(price)
				end
				if Config.Zones[zone].Blackmoney then
					xPlayer.removeAccountMoney('black_money', price)
				else
					xPlayer.removeMoney(price)
				end
				xPlayer.addWeapon(itemName, Config.Zones[zone].Defaultammo)
			else
				local missingMoney = price - money
				xPlayer.showNotification(_U("not_enough", ESX.Math.GroupDigits(missingMoney)))
			end
		else
			xPlayer.showNotification(_U("player_cannot_hold"))
		end
	else
		-- can the player afford this item?
		if Config.Zones[zone].Blackmoney then
			money = xPlayer.getAccount('black_money').money
		else
			money = xPlayer.getMoney()
		end
		if money >= price then
			-- can the player carry the said amount of x item?
			mycount = xPlayer.getInventoryItem(itemName).count
			if xPlayer.canCarryItem(itemName, amount, mycount) then
				if Config.Zones[zone].Blackmoney then
					xPlayer.removeAccountMoney('black_money', price)
					xPlayer.addInventoryItem(itemName, amount, GetCurrentResourceName())
					xPlayer.showNotification(_U("bought", amount, itemLabel, ESX.Math.GroupDigits(price)))
					if Config.Zones[zone].Societymoney then
						local societyAccount = nil
						TriggerEvent(
							"esx_addonaccount:getSharedAccount",
							Config.Zones[zone].Societymoney,
							function(account)
								societyAccount = account
							end
						)
						societyAccount.addMoney(price)
					end
				else
					xPlayer.removeMoney(price)
					xPlayer.addInventoryItem(itemName, amount, GetCurrentResourceName())
					xPlayer.showNotification(_U("bought", amount, itemLabel, ESX.Math.GroupDigits(price)))
					if Config.Zones[zone].Societymoney then
						local societyAccount = nil
						TriggerEvent(
							"esx_addonaccount:getSharedAccount",
							Config.Zones[zone].Societymoney,
							function(account)
								societyAccount = account
							end
						)
						societyAccount.addMoney(price)
					end
				end
			else
				xPlayer.showNotification(_U("player_cannot_hold"))
			end
		else
			local missingMoney = price - money
			xPlayer.showNotification(_U("not_enough", ESX.Math.GroupDigits(missingMoney)))
		end
	end	
end)