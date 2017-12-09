CurrentWeather = 'EXTRASUNNY'
Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false



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
AddEventHandler('updateTime', function(hours, minutes, freeze)
    freezeTime = freeze
    Time.h = hours
    Time.m = minutes
end)

Citizen.CreateThread(function()
    while true do
        if not freezeTime then
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
        else
            Citizen.Wait(0)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('requestSync')
end)
TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
TriggerEvent('chat:addSuggestion', '/time', 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})
TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')


