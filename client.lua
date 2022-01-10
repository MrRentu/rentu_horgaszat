



CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local fetchmyped = GetEntityCoords(ped)
		local sleep = 1000
		local coords = #(fetchmyped - Config['SellFish'])

		if coords <= 5.0 then
			sleep = 1
			if coords <= 2.0 then
			   DrawText3D(Config['SellFish'].x,Config['SellFish'].y,Config['SellFish'].z, "~o~[E]~w~Hal eladása")
				if IsControlJustPressed(0, 38) then
					TriggerServerEvent('rentu_horgaszat:Sell')
					PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
				end
			end
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('fishing:useRod')
AddEventHandler('fishing:useRod', function()
    local Ped = PlayerPedId()
	local pos = GetEntityCoords(PlayerPedId())
	if IsPedInAnyVehicle(Ped) then
		exports['mythic_notify']:DoHudText('error', 'Nem vagy a horgász zónában!')
	else
		if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 then
        StartFishing()
		else
			exports['mythic_notify']:DoHudText('error', 'Nem vagy a horgász zónában!')
		end
	end
	
end)

 StartFishing = function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    ClearPedTasks(ped)
    SetEntityHeading(ped, 147.46)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, false)
    Wait(5000)
    local example = exports['cd_keymaster']:StartKeyMaster()
    if example then
        TriggerServerEvent('rentu_horgaszat:Add')
		exports['mythic_notify']:DoHudText('inform', 'Fogtál egy halat!')
		PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 0)
    else
		exports['mythic_notify']:DoHudText('error', 'A hal leszakadt!')
		PlaySoundFrontend(-1, "MP_Flash", "WastedSounds", 0)
    end
    local Rod = GetClosestObjectOfType(coords, 40.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
	ClearPedTasks(ped)
	SetEntityAsMissionEntity(Rod, true, true)
	DeleteEntity(Rod)
end

 DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
