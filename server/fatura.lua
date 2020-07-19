ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function FaturaGetBilling (accountId, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll([===[
      SELECT * FROM billing WHERE identifier = @identifier
      ]===], { ['@identifier'] = xPlayer.identifier }, cb)
  end 

function getUserFatura(phone_number, firstname, cb)
  MySQL.Async.fetchAll("SELECT firstname, phone_number FROM users WHERE users.firstname = @firstname AND users.phone_number = @phone_number", {
    ['@phone_number'] = phone_number,
	['@firstname'] = firstname
  }, function (data)
    cb(data[1])
  end)
end

RegisterServerEvent('gcPhone:fatura_getBilling')
AddEventHandler('gcPhone:fatura_getBilling', function(phone_number, firstname)
  local sourcePlayer = tonumber(source)
  if phone_number ~= nil and phone_number ~= "" and firstname ~= nil and firstname ~= "" then
    getUserFatura(phone_number, firstname, function (user)
      local accountId = user and user.id
      FaturaGetBilling(accountId, function (billingg)
        TriggerClientEvent('gcPhone:fatura_getBilling', sourcePlayer, billingg)
      end)
    end)
  else
    FaturaGetBilling(nil, function (billingg)
      TriggerClientEvent('gcPhone:fatura_getBilling', sourcePlayer, billingg)
    end)
  end
end)


RegisterServerEvent("gcPhone:faturapayBill")
AddEventHandler("gcPhone:faturapayBill", function(id, sender, amount, target, sharedAccountName)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromIdentifier(sender)
	local xPlayers    = ESX.GetPlayers()
	local foundPlayer = nil
	for i=1, #xPlayers, 1 do
		local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])		
		if xPlayer2.identifier == sender then
			foundPlayer = xPlayer2
			break
		end
	end
		if foundPlayer ~= nil then
			if xPlayer.getMoney() >= amount then
				MySQL.Async.execute(
					'DELETE from billing WHERE id = @id',
					{
						['@id'] = id
					},
					function(rowsChanged)
						xPlayer.removeMoney(amount)
						foundPlayer.addMoney(amount)
						TriggerClientEvent('esx:showNotification', xPlayer.source, "you have ~g~ paid ~s~ an invoice for ~r~ $" .. amount)
						TriggerClientEvent('esx:showNotification', foundPlayer.source, 'you have ~g~ received ~s~ a payment of ~g~$' .. amount)
					end
				)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "You don't have enough money to pay this bill")
				if foundPlayer ~= nil then
					TriggerClientEvent('esx:showNotification', foundPlayer.source, "Person ~r~ does not have ~w~ enough money to pay the bill!")
				end
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'The person is not available')
		end

		TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
			if xPlayer.getAccount('bank').money >= amount then
				MySQL.Async.execute(
					'DELETE from billing WHERE id = @id',
					{
						['@id'] = id
					},
					function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)
						TriggerClientEvent('esx:showNotification', xPlayer.source, "You have ~g~ paid ~s~ an invoice for ~r~$" .. amount)
						if foundPlayer ~= nil then
							TriggerClientEvent('esx:showNotification', foundPlayer.source, 'You have ~g~ received ~s~ a payment of ~g~$' .. amount)
						end
					end
				)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "You don't have enough money to pay this bill")
				if foundPlayer ~= nil then
					TriggerClientEvent('esx:showNotification', foundPlayer.source, "Player ~r~ does not have ~w~ enough money to pay the bill!")
				end
			end
		end)
end)
