if Config.Framework == 'esx' then
    Core = exports['es_extended']:getSharedObject()

    AddEventHandler('esx:onPlayerDeath', function(data)
        TriggerEvent('uniq-deathscreen:client:onPlayerDeath', true)
    end)

    RegisterNetEvent("esx_ambulancejob:revive", function()
        closeUI()
    end)

    SendDistressSignal = function()
        if Config.DispatchSystem then
            local reason = Config.Translation.CriticalCondition
            TriggerEvent("uniq-emsdispatch:client:sendAlert", reason)
        else
            TriggerServerEvent('esx_ambulancejob:onPlayerDistress')
        end
    end

elseif Config.Framework == 'qbcore' then
    Core = exports['qb-core']:GetCoreObject()

    RegisterNetEvent("hospital:client:Revive", function()
        closeUI()
    end)

    SendDistressSignal = function()
        if Config.DispatchSystem then
            local reason = Config.Translation.CriticalCondition
            TriggerEvent("uniq-emsdispatch:client:sendAlert", reason)
        else
            TriggerServerEvent('hospital:server:ambulanceAlert', Config.Translation.CriticalCondition)
        end
    end
end
