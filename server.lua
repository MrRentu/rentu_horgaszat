



discord = {
    ['webhook'] = 'WebHook Link',
    ['name'] = 'Horgászat Log',
    ['image'] = 'https://cdn.discordapp.com/attachments/774536621802389544/899986988386623498/logo.png'
}


RegisterServerEvent('rentu_horgaszat:Add')
AddEventHandler('rentu_horgaszat:Add', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local item = fish
    local chance = math.random(3,7)

    Player.addInventoryItem("fish", chance)
    sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier(), ' Fogott '   ..  chance .. ' halat!')
end)

RegisterServerEvent("rentu_horgaszat:Sell")
AddEventHandler("rentu_horgaszat:Sell", function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local alencount = Player.getInventoryItem('fish').count
    local payment = Config['Payment']
    if alencount <= 1 then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "Nincs elegendö halad az eladáshoz"})			
    else   
        Player.removeInventoryItem('fish', alencount)
        Player.addMoney(payment*alencount)       
        sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier(), ' Kapott ' .. alencount*payment .. ' Ft-ot, a halak eladása miatt!')
end
end)


ESX.RegisterUsableItem('fishingrod', function(source, item) 
    local Player = ESX.GetPlayerFromId(source)
		TriggerClientEvent('fishing:useRod', source)
        sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Elkezdte a horgászatot')
end)

RegisterCommand("fishing", function(source, args, rawCommand)
    local source = source
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fishing:useRod', source)
    sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Elkezdte a horgászatot')
end, false)

sendtodiscordaslog = function(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end

