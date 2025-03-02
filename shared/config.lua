Config = {
    Debug = true,
    VersionChecking = true,
    Framework = 'qbcore', -- esx, qbcore
    DispatchSystem = false, -- set true if you are using uniq dispatch system
    UseRPName = true,
    Timer = 5, -- in seconds
    PriceForDead = 1000,
    RespawnCoords = {
        coords = {
            x = 298.7508,
            y = -1440.6846,
            z = 29.7929
        },
        heading = 44.1302,
    },

    Translation = {
        Suicide = "Suicide",
        Unknown = "Unknown",
        MoneyRemoved = "You have been removed $%s for accepting to die early",
        NotEnoughMoney = "You don't have enoguh money ($%s)",
        CriticalCondition = "Critical Medical Condition",
        
        UI = {
            Title = "VERY SOON",
            Subtitle = "YOU WILL BLEED OUT",
            KilledBy = "KILLED BY",
            AcceptToDie = "ACCEPT TO DIE",
            CallEmergency = "CALL EMERGENCY"
        }
    }
}
