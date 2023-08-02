Config = {}

Config.Framework = 'esx' -- esx/qbcore

Config.Command = {
    enable = true,
    commandName = 'blip'
}

Config.KeyBind = {
    enable = true,
    key = 'H'
}

SonoStaff = function(Framework, source, identifier)
    print(Config.Framework)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        local group = xPlayer.getGroup()
    
        for k,v in pairs(Config.AdminGroup) do 
            if group == v then
                return true
            end
        end
        return false
    elseif Config.Framework == 'qbcore' then
        for k,v in pairs(Config.AdminGroup) do 
            if QBCore.Functions.HasPermission(source, v) then 
                return true 
            end
        end
        return false
    end
end

Config.AdminGroup = {
    'admin'
}

Config.Language = "en"

Config.Translate = {
    ["it"] = {
        ["blips_created"] = "BLIP CREATI",
        ["create_new_blip"] = "CREA NUOVO BLIP",
        ["enter_blip_name"] = "Inserisci il nome del blip",
        ["sprite"] = "Sprite",
        ["color"] = "Colore",
        ["display"] = "Display",
        ["position"] = "Posizione (X,Y,Z)",
        ["create"] = "CREA",
        ["management_blip"] = "GESTIONE BLIP",
        ["delete_blip"] = "ELIMINA BLIP",
        ["apply_modify"] = "APPLICA MODIFICHE",
        ["error_name"] = "Inserisci un nome per il blip",
        ["error_sprite"] = "Inserisci uno sprite per il blip",
        ["error_color"] = "Inserisci un colore per il blip",
        ["error_display"] = "Inserisci un display per il blip",
        ["error_coords"] = "Inserisci delle coordinate per il blip",
        ["blip_created"] = "BLIP CREATO!",
        ["blip_updated"] = "BLIP AGGIORNATO!",
        ["description_keybinds"] = "Apri il menu blip"
    },
    ["en"] = {
        ["blips_created"] = "BLIP CREATED",
        ["create_new_blip"] = "CREATE NEW BLIP",
        ["enter_blip_name"] = "Enter the name blip",
        ["sprite"] = "Sprite",
        ["color"] = "Color",
        ["display"] = "Display",
        ["position"] = "Position (X,Y,Z)",
        ["create"] = "CREATE",
        ["management_blip"] = "MANAGEMENT BLIP",
        ["delete_blip"] = "DELETE BLIP",
        ["apply_modify"] = "APPLY MODIFY",
        ["error_name"] = "Enter a name for the blip",
        ["error_sprite"] = "Enter a sprite for the blip",
        ["error_color"] = "Enter a color for the blip",
        ["error_display"] = "Enter a display for the blip",
        ["error_coords"] = "Enter coordinates for the blip",
        ["blip_created"] = "BLIP CREATED!",
        ["blip_updated"] = "BLIP UPDATED!",
        ["description_keybinds"] = "Open the blip menu"
    }
}
