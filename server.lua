if Config.Framework == 'esx' then 
    ESX = exports.es_extended:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end


CheckFileBlip = function()
    local nomeRisorsa = GetCurrentResourceName()
    local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')

    if fileBlip == nil then
        print('^1Errore: file blips.json non trovato^7')
        return false
    else
        return true
    end
end

AddEventHandler('onResourceStart', function(resName)
    if resName == GetCurrentResourceName() then
        CheckFileBlip()
    end
end)

if Config.Framework == 'esx' then 
    ESX.RegisterServerCallback('ricky-server:getBlips', function(source, cb)
        local nomeRisorsa = GetCurrentResourceName()
        local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')
    
        if CheckFileBlip() == false then return end 
    
        local blips = json.decode(fileBlip)
    end)
elseif Config.Framework == 'qbcore' then
    QBCore.Functions.CreateCallback('ricky-server:getBlips', function(source, cb)
        local nomeRisorsa = GetCurrentResourceName()
        local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')
    
        if CheckFileBlip() == false then return end 
    
        local blips = json.decode(fileBlip)
    end)
end

if Config.Framework == 'esx' then 
    ESX.RegisterServerCallback('ricky-server:blipGetCreatedBlip', function(source, cb)
        local nomeRisorsa = GetCurrentResourceName()
        local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')
    
        if CheckFileBlip() == false then return end 
    
        local blips = {}
    
        for k, v in pairs(json.decode(fileBlip)) do
            table.insert(blips, {
                name = v.name,
                sprite = v.sprite,
                color = v.color,
                coords = v.coords,
                display = v.display,
                x = v.coords.x,
                y = v.coords.y,
                z = v.coords.z,
                id = k
            })
        end
    
        cb(blips)
    end)
elseif Config.Framework == 'qbcore' then
    QBCore.Functions.CreateCallback('ricky-server:blipGetCreatedBlip', function(source, cb)
        local nomeRisorsa = GetCurrentResourceName()
        local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')
    
        if CheckFileBlip() == false then return end 
    
        local blips = {}
    
        for k, v in pairs(json.decode(fileBlip)) do
            table.insert(blips, {
                name = v.name,
                sprite = v.sprite,
                color = v.color,
                coords = v.coords,
                display = v.display,
                x = v.coords.x,
                y = v.coords.y,
                z = v.coords.z,
                id = k
            })
        end
    
        cb(blips)
    end)
end

function string.split(inputString, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    inputString:gsub(pattern, function(value) result[#result + 1] = tonumber(value) end)
    return result
end

RegisterServerEvent('ricky-server:blipCreateBlip')
AddEventHandler('ricky-server:blipCreateBlip', function(name, sprite, color, coords, display)
    local nomeRisorsa = GetCurrentResourceName()
    local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')

    if CheckFileBlip() == false then return end 

    local blips = json.decode(fileBlip)

    local numbers = string.split(coords, ",")

    coords = {
        x = tonumber(numbers[1]),
        y = tonumber(numbers[2]),
        z = tonumber(numbers[3])
    }
    
    local blip = {
        name = name,
        sprite = sprite,
        color = color,
        coords = coords,
        display = display
    }

    table.insert(blips, blip)

    SaveResourceFile(nomeRisorsa, 'blips.json', json.encode(blips, {indent = true}), -1)
    TriggerClientEvent('ricky-client:blipUpdateCreatedBlip', -1)
end)

RegisterServerEvent('ricky-server:blipDeleteBlip')
AddEventHandler('ricky-server:blipDeleteBlip', function(idBlip)
    local nomeRisorsa = GetCurrentResourceName()
    local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')

    if CheckFileBlip() == false then return end 

    local blips = json.decode(fileBlip)

    table.remove(blips, idBlip)

    SaveResourceFile(nomeRisorsa, 'blips.json', json.encode(blips, {indent = true}), -1)
    TriggerClientEvent('ricky-client:blipUpdateCreatedBlip', -1)
end)


RegisterServerEvent('ricky-server:blipEditBlip')
AddEventHandler('ricky-server:blipEditBlip', function(id, name, sprite, color, coords, display)
    local nomeRisorsa = GetCurrentResourceName()
    local fileBlip = LoadResourceFile(nomeRisorsa, 'blips.json')

    if CheckFileBlip() == false then return end 

    local blips = json.decode(fileBlip)

    local numbers = string.split(coords, ",")

    coords = {
        x = tonumber(numbers[1]),
        y = tonumber(numbers[2]),
        z = tonumber(numbers[3])
    }


    blips[tonumber(id)] = {
        name = name,
        sprite = sprite,
        color = color,
        coords = coords,
        display = display
    }

    SaveResourceFile(nomeRisorsa, 'blips.json', json.encode(blips, {indent = true}), -1)
    TriggerClientEvent('ricky-client:blipUpdateCreatedBlip', -1)
end)


if Config.Framework == 'esx' then 
    ESX.RegisterServerCallback('ricky-server:blipSonoStaff', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        cb(SonoStaff(ESX, xPlayer.source, xPlayer.identifier))
    end)
elseif Config.Framework == 'qbcore' then
    QBCore.Functions.CreateCallback('ricky-server:blipSonoStaff', function(source, cb)
        local xPlayer = QBCore.Functions.GetPlayer(source)

        cb(SonoStaff(QBCore, source, xPlayer.identifier))
    end)
end


