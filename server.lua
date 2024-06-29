ESX = exports["es_extended"]:getSharedObject()
ESX.RegisterServerCallback('vs_bikerent:checkmoney', function(source, cb)
    local oplata = Config.RentalCost
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.RentalCost then
        xPlayer.removeMoney(Config.RentalCost)
        cb(true)
    else
        TriggerClientEvent('wl_notify:Alert', source, 'Błąd', 'Opłata za Pojazd wynosi '..oplata..'$', 5000, 'error', playSound)
        cb(false)
    end
end)

