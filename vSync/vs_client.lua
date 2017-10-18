CurrentWeather = 'EXTRASUNNY'
Time = {}
Time.h = 12
Time.m = 0


RegisterNetEvent('updateWeather')
AddEventHandler('updateWeather', function(NewWeather)
    CurrentWeather = NewWeather
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        ClearWeatherTypePersist()
        SetWeatherTypeNowPersist(CurrentWeather)
        SetWeatherTypeNow(CurrentWeather)
        SetWeatherTypePersist(CurrentWeather)
        if CurrentWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('updateTime')
AddEventHandler('updateTime', function(hours, minutes)
    Time.h = hours
    Time.m = minutes
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        NetworkOverrideClockTime(Time.h, Time.m, 0)
        Time.m = Time.m + 1
        if Time.m > 59 then
            Time.m = 0
            Time.h = Time.h + 1
            if Time.h > 23 then
                Time.h = 0
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('requestSync')
end)