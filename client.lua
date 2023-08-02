if Config.Framework == 'esx' then 
    ESX = exports.es_extended:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local createdBlip = nil

SonoStaff1 = function()
    if Config.Framework == 'esx' then 
        local staff1 = nil
        ESX.TriggerServerCallback('ricky-server:blipSonoStaff', function(staff) 
            staff1 = staff        
        end)
        while staff1 == nil do
            Wait(100)
        end
        return staff1
    elseif Config.Framework == 'qbcore' then
        local staff1 = nil
        QBCore.Functions.TriggerCallback('ricky-server:blipSonoStaff', function(staff) 
            staff1 = staff        
        end)
        while staff1 == nil do
            Wait(100)
        end
        return staff1
    end
end

Citizen.CreateThread(function()

    if Config.Framework == 'esx' then 
        while ESX.IsPlayerLoaded() == false do
            Wait(100)
        end
    
       ESX.TriggerServerCallback('ricky-server:blipGetCreatedBlip', function(blip) 
             createdBlip = blip
       end)
    
       while createdBlip == nil do
          Wait(100)
       end
    elseif Config.Framework == 'qbcore' then
        while QBCore.Functions.GetPlayerData().job == nil do
            Wait(100)
        end
    
       QBCore.Functions.TriggerCallback('ricky-server:blipGetCreatedBlip', function(blip) 
             createdBlip = blip
       end)
    
       while createdBlip == nil do
          Wait(100)
       end
    end

   UpdateBlip()
end)

RemoveAllBlip = function()
    for k,v in pairs(createdBlip) do
        RemoveBlip(v.numeroBlip)
    end
    createdBlip = nil
end

UpdateBlip = function()
    Citizen.CreateThread(function()
        for k,v in pairs(createdBlip) do
              local blip = AddBlipForCoord(v.x, v.y, v.z)
              v.numeroBlip = blip
              SetBlipSprite(blip, tonumber(v.sprite))
              SetBlipDisplay(blip, tonumber(v.display))
              SetBlipScale(blip, 1.0)
              SetBlipColour(blip, tonumber(v.color))
              SetBlipAsShortRange(blip, true)
              BeginTextCommandSetBlipName("STRING")
              AddTextComponentString(v.name)
              EndTextCommandSetBlipName(blip)
           end
    end)
end


postNUI = function(data)
    SendNUIMessage(data)
end


OpenBlipCreator = function()
    if Config.Framework == 'esx' then 
        ESX.TriggerServerCallback('ricky-server:blipGetCreatedBlip', function(createdBlip) 
            if SonoStaff1() == false then 
                return 
            end
            SetNuiFocus(true, true)
            postNUI({
                type = "SET_CONFIG",
                config = Config
            })
            postNUI({
                type = "OPEN",
                createdBlip = createdBlip
            })
        end)
    elseif Config.Framework == 'qbcore' then
        QBCore.Functions.TriggerCallback('ricky-server:blipGetCreatedBlip', function(createdBlip) 
            if SonoStaff1() == false then 
                return 
            end
            SetNuiFocus(true, true)
            postNUI({
                type = "SET_CONFIG",
                config = Config
            })
            postNUI({
                type = "OPEN",
                createdBlip = createdBlip
            })
        end)
    end
end

RegisterNUICallback('setMyCoords', function(data, cb)
    postNUI({
        type = "SET_COORDS",
        coords = GetEntityCoords(PlayerPedId())
    })
end)

RegisterNUICallback('createBlip', function(data, cb)
    local name = data.name
    local sprite = data.sprite
    local color = data.color
    local coords = data.coords
    local display = data.display
    TriggerServerEvent('ricky-server:blipCreateBlip', name, sprite, color, coords, display)
end)

RegisterNUICallback('deleteBlip', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-server:blipDeleteBlip', id)
end)

RegisterNUICallback('editBlip', function(data, cb)
    local id = data.idBlip
    local name = data.name
    local sprite = data.sprite
    local color = data.color
    local coords = data.coords
    local display = data.display
    TriggerServerEvent('ricky-server:blipEditBlip', id, name, sprite, color, coords, display)
end)

RegisterNetEvent('ricky-client:blipUpdateCreatedBlip')
AddEventHandler('ricky-client:blipUpdateCreatedBlip', function()
    ESX.TriggerServerCallback('ricky-server:blipGetCreatedBlip', function(createdBlip1) 
        postNUI({
            type = "UPDATE_CREATED_BLIP",
            createdBlip = createdBlip1
        })
        RemoveAllBlip()

    createdBlip = createdBlip1

  while createdBlip == nil do
     Wait(100)
  end

  UpdateBlip()
    end)
end)


RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
end)

if Config.Command.enable then
    RegisterCommand(Config.Command.commandName, function(source, args, rawCommand)
        OpenBlipCreator()
    end)
end

if Config.KeyBind.enable then
    RegisterKeyMapping('-+blip', Config.Translate[Config.Language]["description_keybinds"], 'keyboard', Config.KeyBind.key)
    RegisterCommand('-+blip', function(source, args, rawCommand)
        OpenBlipCreator()
    end)
    TriggerEvent('chat:removeSuggestion', '/-+blip')
end
