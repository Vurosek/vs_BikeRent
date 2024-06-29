local rentingBike = false 
local bikeEntity = nil 
local bikeRemovalTimer = nil


ESX = exports["es_extended"]:getSharedObject()
function SpawnBike()
    local bikeHash = GetHashKey(Config.BikeModel1)
    RequestModel(bikeHash)
    while not HasModelLoaded(bikeHash) do
        Wait(1)
    end
    ESX.TriggerServerCallback('vs_bikerent:checkmoney', function(cb)
        if cb then
            bikeEntity = CreateVehicle(bikeHash, Config.SpawnLocation, true, false)
            SetEntityAsMissionEntity(bikeEntity, true, true)
            TaskWarpPedIntoVehicle(PlayerPedId(), bikeEntity, -1)
            lib.notify({
                title = 'Informacja',
                description = 'Pobrano opłatę 150$',
                icon = 'money-bill',
                   iconColor = '#008f13',
                iconAnimation = 'beat',
                sound = 'bank',
                position = 'top-left'
            })
            end
        end)
    end


function SpawnPed()
    local pedHash = GetHashKey("u_m_m_aldinapoli")
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Wait(1)
    end

    local ped = CreatePed(4, pedHash, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, 0.0, true, true)
    SetEntityHeading(ped, Config.PedH)  
    FreezeEntityPosition(ped, true) 
end


function ReturnBike()
    if DoesEntityExist(bikeEntity) then
        DeleteEntity(bikeEntity)
    end
    bikeEntity = nil
end


function DisplayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end


function Notify(text)

    TriggerEvent('esx:showNotification', text)
end


function MonitorBikeUsage()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)

            if bikeEntity and not IsPedInVehicle(PlayerPedId(), bikeEntity, false) then
                if not bikeRemovalTimer then
                    bikeRemovalTimer = GetGameTimer() + 30000 -- Ustaw timer na 30 sekund
                    Notify("Rower zostanie usunięty po 30 sekundach, jeśli na niego nie wrócisz.")
                elseif GetGameTimer() > bikeRemovalTimer then
                    ReturnBike() -- Usuń rower po 30 sekundach
                    bikeRemovalTimer = nil
                end
            else
                bikeRemovalTimer = nil -- Zresetuj timer, jeśli gracz wróci na rower
            end
        end
    end)
end


Citizen.CreateThread(function()
    local RentBlip = {
        markerType = 1, 
        pos = RentBlip,
        size = vector3(1.5, 1.5, 1.0), 
        color = { r = 0, g = 255, b = 0 }, 
    }

    local RentBlip = AddBlipForCoord(-1033.5906, -2736.4084, 20.1693)
    SetBlipSprite(RentBlip, 523)
    SetBlipScale(RentBlip, 0.8)
    SetBlipColour(RentBlip, 2)
    SetBlipAsShortRange(RentBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wypożyczalnia rowerów")
    EndTextCommandSetBlipName(RentBlip)

  
    SpawnPed()


            
        
    end)


RegisterNetEvent('vs_bikerent:SpawnBike')
AddEventHandler('vs_bikerent:SpawnBike', function()
    RentBike()
end)
function RentBike()
    if not rentingBike then
        rentingBike = true
        SpawnBike()
        rentingBike = false
        MonitorBikeUsage()
    end
end

RegisterCommand('oddajrower', function()
    if not rentingBike then
        ReturnBike()
    end
end)

exports.ox_target:addSphereZone({
    coords = vector3(Config.Target), 
    radius = 5,
    debug = false,
    options = {
        {
            name = Config.RentName,
            icon = Config.RentIcon,
            label = Config.RentLabel,
            event = "vs_bikerent:SpawnBike",
            distance = 2,
        }
    }
})


