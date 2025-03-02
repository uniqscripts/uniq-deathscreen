if Config.Framework == 'esx' then
    Core = exports['es_extended']:getSharedObject()

    Core.RegisterServerCallback("uniq-deathscreen:server:removeMoneyAmount", function(source, cb, amount, account)
        local xPlayer = Core.GetPlayerFromId(source)
        account = account or 'money'
        
        if xPlayer then
            if account == 'money' then
                if xPlayer.getMoney() >= amount then
                    xPlayer.removeMoney(amount)
                    cb(true)
                else
                    cb(false)
                end
            else
                if xPlayer.getAccount(account).money >= amount then
                    xPlayer.removeAccountMoney(account, amount)
                    cb(true)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    end)

    GetPlayer = function (pId)
        return Core.GetPlayerFromId(pId)
    end

    GetPlayerRPName = function (pId)
        return Core.GetPlayerFromId(pId).name
    end
elseif Config.Framework == 'qbcore' then
    Core = exports['qb-core']:GetCoreObject()

    Core.Functions.CreateCallback("uniq-deathscreen:server:removeMoneyAmount", function(source, cb, amount, account)
        local Player = Core.Functions.GetPlayer(source)
        account = account or "cash"
        
        if Player then
            if Player.PlayerData.money[account] >= amount then
                Player.Functions.RemoveMoney(account, amount)
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    RegisterNetEvent('hospital:server:SetLaststandStatus')
    AddEventHandler('hospital:server:SetLaststandStatus', function(isDead)
        TriggerClientEvent('uniq-deathscreen:client:onPlayerDeath', source, isDead)
    end)

    GetPlayer = function (pId)
        return Core.Functions.GetPlayer(pId)
    end

    GetPlayerRPName = function (pId)
        return Core.Functions.GetPlayer(pId).PlayerData.charinfo.firstname .. ' ' .. Core.Functions.GetPlayer(pId).PlayerData.charinfo.lastname
    end
end
