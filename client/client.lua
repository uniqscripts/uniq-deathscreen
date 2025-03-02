RegisterNetEvent('uniq-deathscreen:client:onPlayerDeath')
AddEventHandler('uniq-deathscreen:client:onPlayerDeath', function(isDead)
    if isDead then
        local killername = nil
        showUI()

        local PedKiller = GetPedSourceOfDeath(PlayerPedId())
        local killerid = NetworkGetPlayerIndexFromPed(PedKiller)

        if IsEntityAVehicle(PedKiller) and IsEntityAPed(GetVehiclePedIsIn(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
            killerid = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
        end

        if (killerid == -1) then
            killername = Config.Translation.Suicide
        elseif (killerid == nil) then
            killername = Config.Translation.Unknown
        elseif (killerid ~= -1) then

            if Config.UseRPName then
                TriggerServerEvent('uniq-deathscreen:server:getRPName', GetPlayerServerId(killerid))
            else
                killername = GetPlayerName(killerid)
            end
        end

        SendNUIMessage({
            type = 'setUPValues', 
            killer = killername, 
            timer = Config.Timer,
            translations = Config.Translation.UI
        })
    end
end)

RegisterNetEvent('uniq-deathscreen:client:getRPName')
AddEventHandler('uniq-deathscreen:client:getRPName', function(name)
    SendNUIMessage({
        type = 'setUPValues', 
        killer = name, 
        timer = Config.Timer,
        translations = Config.Translation.UI
    })
end)

showUI = function()
    SendNUIMessage({type = "show", status = true})
    SetNuiFocus(true, true)
end

closeUI = function()
    SendNUIMessage({type = "show", status = false})
    SetNuiFocus(false, false)
end

RegisterNuiCallback("acceptToDie", function(data)
    closeUI()
    if Config.Framework == 'esx' then
        Core.TriggerServerCallback('uniq-deathscreen:server:removeMoneyAmount', function(success)
            if success then
                Core.ShowNotification((Config.Translation.MoneyRemoved):format(Config.PriceForDead))
                TriggerEvent("esx_ambulancejob:revive")
            else
                Core.ShowNotification((Config.Translation.NotEnoughMoney):format(Config.PriceForDead))
            end
        end, 500, 'money')
    elseif Config.Framework == 'qbcore' then
        Core.Functions.TriggerCallback('uniq-deathscreen:server:removeMoneyAmount', function(success)
            if success then
                Core.Functions.Notify((Config.Translation.MoneyRemoved):format(Config.PriceForDead), 'primary', 5000)
                TriggerEvent("hospital:client:Revive")
            else
                Core.Functions.Notify((Config.Translation.NotEnoughMoney):format(Config.PriceForDead), 'error', 5000)
            end
        end, 500, 'cash')
    end
end)

RegisterNuiCallback("callEmergency", function(data)
    SendDistressSignal()
end)

RegisterNuiCallback("timeExpired", function(data)
    closeUI()
    if Config.Framework == 'esx' then
        TriggerEvent("esx_ambulancejob:revive")
    elseif Config.Framework == 'qbcore' then
        TriggerEvent("hospital:client:RespawnAtHospital")
    end
end)