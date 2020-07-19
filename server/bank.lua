TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('gcPhone:transfer')
AddEventHandler('gcPhone:transfer', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank',
                               'Transfer ',
                               'You cant transfer to yourself!',
                               'CHAR_BANK_MAZE', 9)
			TriggerEvent('esx:importantlogs', "[gcphone] "..xPlayer.identifier.." tried to transfer $ "..tostring(amountt))
		else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Bank', 'Transfer',
                                   'You cant transfer to yourself!',
                                   'CHAR_BANK_MAZE', 9)
				TriggerEvent('esx:importantlogs', "[gcphone] "..xPlayer.identifier.." tried to transfer $ "..tostring(amountt).." a "..zPlayer.identifier.. " but couldn't")
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Bank', 'Transfer ',
                                   'You transferred ~r~$' .. amountt ..
                                       '~s~ à ~r~' .. to .. ' .',
                                   'CHAR_BANK_MAZE', 9)
                TriggerClientEvent('esx:showAdvancedNotification', to, 'Bank',
                                   'Transfer ', 'You received ~r~$' ..
                                       amountt .. '~s~ de ~r~' .. _source ..
                                       ' .', 'CHAR_BANK_MAZE', 9)
				TriggerEvent('esx:importantlogs', "[gcphone] "..xPlayer.identifier.." transfers it $ "..tostring(amountt).." a "..zPlayer.identifier)
            end
        end
	else
		TriggerEvent('esx:importantlogs', "[gcphone] "..xPlayer.identifier.." tried to transfer $"..tostring(amountt).." a id: "..tostring(to).. " The player is not online so no money transfer")
    end
end)

function getorfirstname (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local firstname = getFirstname(identifier)
	local lastname = getLastname(identifier)
end

function getFirstname(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.firstname FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].firstname
    end
    return nil
end

function getLastname(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.lastname FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].lastname
    end
    return nil
end
