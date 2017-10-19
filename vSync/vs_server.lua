------------------ change this -------------------

admins = {
    'steam:110000105959047',
    --'license:1234975143578921327',
}

--------------------------------------------------


















-------------------- DON'T CHANGE THIS --------------------
AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}
CurrentWeather = "EXTRASUNNY"
Time = {}
Time.h = 12
Time.m = 0



RegisterServerEvent('requestSync')
AddEventHandler('requestSync', function()
    TriggerClientEvent('updateWeather', -1, CurrentWeather)
    TriggerClientEvent('updateTime', -1, Time.h, Time.m)
end)

RegisterCommand('weather', function(source, args, rawCommand)
    if source == 0 then
        print("You can't use this command from the console!")
        return
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax.')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^3Weather has been upated.')
                    CurrentWeather = string.upper(args[1])
                    TriggerEvent('requestSync')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /weather denied.')
        end
    end
end, false)


RegisterCommand('morning', function(source)
    if isAllowedToChange(source) then
        Time.h = 9
        Time.m = 0
        TriggerEvent('requestSync')
    end
end)
RegisterCommand('noon', function(source)
    if isAllowedToChange(source) then
        Time.h = 12
        Time.m = 0
        TriggerEvent('requestSync')
    end
end)
RegisterCommand('evening', function(source)
    if isAllowedToChange(source) then
        Time.h = 18
        Time.m = 0
        TriggerEvent('requestSync')
    end
end)
RegisterCommand('night', function(source)
    if isAllowedToChange(source) then
        Time.h = 23
        Time.m = 0
        TriggerEvent('requestSync')
    end
end)


RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then
        print("You can't use this command from the console!")
        return
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                Time.h = tonumber(args[1])
                Time.m = tonumber(args[2])
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^2Time has been updated.')
                TriggerEvent('requestSync')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /time denied.')
        end
    end
end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if pid == id then
                allowed = true
            end
        end
    end
    return allowed
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('updateTime', -1, Time.h, Time.m)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('updateWeather', -1, CurrentWeather)
    end
end)