local oldLoad = load
local ResourceName = (GetCurrentResourceName())
local triggerServerEvent = (TriggerServerEvent)
local V = {"/e", "/f", "/d"}
local X = GetOnscreenKeyboardResult()


if X ~= nil and X ~= false and X ~= true then
    for C, Y in pairs(V) do
        if X:match(Y) then
            triggerServerEvent('securenet:ban', 'modmenu', ResourceName)
            Citizen.Wait(500)
            while true do
                ForceSocialClubUpdate()
            end
        end
        Wait(1)
    end
end

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)
		local re = GetEntityScript(car)

		if re ~= nil and re ~= "" and re ~= " " then
			local allowed = false
			for j,v in ipairs(SecureNet.Carwhitelist) do
				if v == re  then
					allowed = true
					break
				end
			end

			if not allowed then
				DeleteEntity(car)
				if NetworkGetEntityOwner(car) == -1 then
                    triggerServerEvent('snss')
                    Wait(1000)
                    triggerServerEvent('securenet:ban', 'tried to spawn car', ResourceName)
				end
			end
		end
	end
end

function antiplatechanger()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate and GetHashKey(vehicle) and VEH == vehicle and PLATE ~= plate then
            triggerServerEvent('securenet:ban', 'changed plate', ResourceName)
        end

        VEH = vehicle
        PLATE = plate
    else
        VEH = nil
        PLATE = nil
    end
end

function antiTinyPlayer()
    if GetPedConfigFlag(PlayerPedId(), 223, true) then
        triggerServerEvent('snss')
        Wait(5000)
        triggerServerEvent('securenet:ban', 'tiny', ResourceName)
    end
end

function resetloop()
    SetPedInfiniteAmmoClip(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityCanBeDamaged(PlayerPedId(), true)
    ResetEntityAlpha(PlayerPedId())
end

if SecureNet.config.AntiEvents then
        for i=1, #SecureNet.ClientEvents do
            AddEventHandler(SecureNet.ClientEvents[i], function(...)
                local parameters = json.encode({...})
                triggerServerEvent('snss')
                Wait(1000)
                triggerServerEvent('securenet:ban', 'blacklisted event', ResourceName)
            end)
        end
end

Citizen.CreateThread(function() 
	while true do
        Citizen.Wait(20000)
        if checkGlobalVariable() then
            print("checkglobalvaribale")
            ForceSocialClubUpdate()
        end
		if ForceSocialClubUpdate == nil then 
            triggerServerEvent('snss')
			triggerServerEvent('securenet:ban', 'fscu', ResourceName)
		end
	end 
 end)

 Citizen.CreateThread(function()
    if #SecureNet.Dicts > 0 then
        for i = 1, #SecureNet.Dicts, 1 do
            SetStreamedTextureDictAsNoLongerNeeded(SecureNet.Dicts[i])
        end
    end
    while #SecureNet.Dicts > 0 do
        Citizen.Wait(5000)
        for i = 1, #SecureNet.Dicts, 1 do
            if HasStreamedTextureDictLoaded(SecureNet.Dicts[i]) then
                triggerServerEvent('nunu:ban', 'detected menu', ResourceName)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(30000)
        if (_G == nil or _G == {} or _G == '') then
            triggerServerEvent('securenet:ban', 1, ResourceName)
        end
        Citizen.Wait(2500)
        if (load ~= oldLoad or load == nil or oldLoad == nil) then
            triggerServerEvent('securenet:ban', 6, ResourceName)
        end
    end
end)

checkGlobalVariable = function()
    for _i in pairs(SecureNet.Functions) do
        if (_G[SecureNet.Functions[_i] ] ~= nil) then
            return true
        else
            return false
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(25000)
        for _, banmenus in pairs(SecureNet.MenuFunctions) do
            local menuFunction = banmenus[1]
            local menuName = banmenus[2]
            local returnType = type(SecureNet.MenuFunctions)
            if returnType == 'function' then
                print("banmenus")
                ForceSocialClubUpdate()
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        for _, banmenus in pairs(SecureNet.MenuTables) do
            local menuTable = banmenus[1]
            local menuName = banmenus[2]
            local variable = _G[menuTable]
            local variableType = type(variable)
            if variableType == 'table' then
                print("banmenus2")
                ForceSocialClubUpdate()
            end
        end
    end
end)

local oldLoadResourceFile = LoadResourceFile
LoadResourceFile = function(_resourceName, _fileName)
    if (_resourceName ~= ResourceName) then
        triggerServerEvent('securenet:ban', 3, ResourceName)
    else
        oldLoadResourceFile(_resourceName, _fileName)
    end
end

local oldPrint = print
print = function(...)
    for k,v in ipairs({...}) do
        if (v:find(GetCurrentServerEndpoint())) then
            triggerServerEvent('securenet:ban', 'menu injected', ResourceName)
        else
            oldPrint(v)
        end
    end
end


local oldTrace = Citizen.Trace
Citizen.Trace = function(...)
    for k,v in ipairs({...}) do
        if (v:find(' menu property changed: { ')) then
            triggerServerEvent('securenet:ban', 'menu injected', ResourceName)
        else
            oldTrace(v)
        end
    end
end

Citizen.CreateThread(function()
    local checkw = GetLocalPlayerAimState()
    while true do
        if IsPedShooting(PlayerPedId()) then
            if checkw ~= 3 and not IsPedInAnyVehicle(PlayerPedId(), true) then
                    triggerServerEvent('snss')
                    Wait(1000)
                    DropPlayer(PlayerPedId(), 'Aim Assist')
            end
        end
        Citizen.Wait(5000)
    end
end)

local sscount = 0

local InsertKeys = {
	["DELETE"] = 214, ["INSERT"] = 121, ["HOME"] = 212, ["NUMPAD7"] = 117, ["F8"] = 169, ["F11"] = 344, ["G"] = 47
}

CreateThread(function()
	while true do
		Citizen.Wait(50)
		if not timeoutSS then   
			for i,v in pairs(InsertKeys) do
				if IsControlJustPressed(0, v) or IsDisabledControlJustPressed(0, v) then
					timeoutSS = true
					Citizen.Wait(1000)
					sssource = sscount + 1
                    triggerServerEvent('snss')
					Citizen.SetTimeout(15000, function() 
						timeoutSS = false
					end)
				end
			end
		end
	end
end)

--[[ better function
    CreateThread(function()
        while true do
            Citizen.Wait(3)
            if not timeoutSS then   
                local keyPressed = false
                for _, key in ipairs(InsertKeys) do
                    if IsControlJustPressed(0, key) or IsDisabledControlJustPressed(0, key) then
                        keyPressed = true
                        break
                    end
                end
                if keyPressed then
                    timeoutSS = true
                    Citizen.Wait(1000)
                    sscount = sscount + 1
                    TriggerServerEvent('snss')
                    Citizen.SetTimeout(15000, function() 
                        timeoutSS = false
                    end)
                end
            end
            Citizen.Wait(1000)
        end
    end)
]]

Citizen.CreateThread(function()
    local spectatorflag = 0
    local noclipFlag = {}
    while true do
        Wait(5000)
        TriggerServerEventInternal("securenet", "securenet")
        DestroyAllCams(1)
        StopSound(-1)
        RemoveParticleFxInRange(0,0,0, 999999999)
        local vehiclePool = GetGamePool("CVehicle")
            for _, vehicle in ipairs(vehiclePool) do
                if IsEntityAttachedToAnyPed(vehicle) then
                    DetachEntity(vehicle, true, true)
                    DeleteEntity(vehicle)
                    NetworkAllowLocalEntityAttachment(vehicle, false)
                end
            end
            NetworkAllowLocalEntityAttachment(PlayerPedId(), false)
        Citizen.Wait(3000)
        antiplatechanger()
        antiTinyPlayer()
        resetloop()
        triggerServerEvent('snservercheck')

        if IsPedInAnyVehicle(PlayerPedId(), false) then
			local vehiclein = GetVehiclePedIsIn(PlayerPedId(), 0)
			checkCar(vehiclein)
			if GetPlayerVehicleDamageModifier(PlayerId()) > 1.0 then
                triggerServerEvent('snss')
                Wait(1000)
                triggerServerEvent('securenet:ban', 'car damage hack', ResourceName)
			end
			if GetVehicleCheatPowerIncrease(vehiclein) > 1.0 then
                triggerServerEvent('snss')
                Wait(1000)
                triggerServerEvent('securenet:ban', 'car speed hack', ResourceName)
			end
		end

        if NetworkIsInSpectatorMode() then
            triggerServerEvent('snss')
            Wait(10000)
            print("spectate ban")
            triggerServerEvent('securenet:ban', 'spectate', ResourceName)
        end

        local camCoords = #(GetEntityCoords(PlayerPedId()) - GetFinalRenderedCamCoord())
        if camCoords >= 10.0 then
            spectatorflag = spectatorflag + 1
        end

        if spectatorflag >= 22 then
            triggerServerEvent('snss')
            Wait(1000)
            triggerServerEvent('securenet:ban', 'spectate 2', ResourceName)
        end    

        if IsEntityVisible(PlayerPedId()) and not IsEntityVisibleToScript(PlayerPedId()) or (GetEntityAlpha(PlayerPedId()) <= 150 and GetEntityAlpha(PlayerPedId()) ~= 0) then
            triggerServerEvent('snss')
            Wait(10000)
            triggerServerEvent('securenet:ban', 'invisibility', ResourceName)
        end

        if GetUsingnightvision(true) and not IsPedInAnyHeli(PlayerPedId()) then
            triggerServerEvent('snss')
            Wait(10000)
            triggerServerEvent('securenet:ban', 'night vision', ResourceName)
        end

        if GetUsingseethrough(true) and not IsPedInAnyHeli(PlayerPedId()) then
            triggerServerEvent('snss')
            Wait(10000)
            triggerServerEvent('securenet:ban', 'thermal vision', ResourceName)
        end

        if IsPedDoingBeastJump(PlayerPedId()) then
            triggerServerEvent('snss')
            Wait(10000)
            triggerServerEvent('securenet:ban', 'beast jump', ResourceName)
        end

        local playerId = PlayerId()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            local heightAboveGround = GetEntityHeightAboveGround(PlayerPedId())
            
            if heightAboveGround > 4.0 and not IsPedFalling(PlayerPedId()) then
                if not noclipFlag[playerId] then
                    noclipFlag[playerId] = 1
                else
                    noclipFlag[playerId] = noclipFlag[playerId] + 1
                end

                if noclipFlag[playerId] >= 10 then
                    triggerServerEvent('snss')
                    Wait(1000)
                    triggerServerEvent('securenet:ban', 'noclip', ResourceName)
                    break
                end
            else
                noclipFlag[playerId] = nil
            end
        else
            noclipFlag[playerId] = nil
        end

        local playerFlags = {}
        function CheckPlayerFlags(playerId)
            local playerPed = GetPlayerPed(-1)
            local playerName = GetPlayerName(playerId)
        
            if not IsPedInAnyVehicle(playerPed, 1) then
                if GetEntitySpeed(playerPed) > 15 then
                    if not IsPedInAnyVehicle(playerPed, true) and not IsPedFalling(playerPed) and not IsPedInParachuteFreeFall(playerPed) and not IsPedJumpingOutOfVehicle(playerPed) and not IsPedRagdoll(playerPed) and not IsEntityAttached(playerPed) then
                        if not playerFlags[playerId] then
                            playerFlags[playerId] = 1
                        else
                            playerFlags[playerId] = playerFlags[playerId] + 1
                        end
        
                        if playerFlags[playerId] >= 5 then
                            triggerServerEvent('snss')
                            print("flag speed")
                            triggerServerEvent('securenet:ban', 'speedhack', ResourceName)
                        end
                    end
                end
            end
         
        Citizen.CreateThread(function()
            local playerId = PlayerId()
            while true do
                CheckPlayerFlags(playerId)
                Citizen.Wait(500)
            end
        end)	
    end
end
end)

Citizen.CreateThread(function()
    local a = GetLabelText(SecureNet.AntiTextEntries[i])
    while true do
        for i = 1, #SecureNet.AntiTextEntries, 1 do
            if a ~= nil and a ~= "NULL" then
                if a == 'someshit' then break end
                triggerServerEvent('snss')
                print("text entries ban")
                TriggerServerEvent('securenet:ban', 'mod menu', GetCurrentResourceName())
            end
        end
        Citizen.Wait(5000)
    end
end)

AddEventHandler("onClientResourceStop", function(resource)
    if GetCurrentResourceName() == resource then
        print("onClientResourceStop")
        ForceSocialClubUpdate()
    end
end)

RegisterNetEvent('ow:Checkdamage')
AddEventHandler('ow:Checkdamage', function(hash)
    if not HasPedGotWeapon(PlayerPedId(), hash, false) then
		triggerServerEvent('nunu:ban', 'cheater', ResourceName)
    end
end)

RegisterNUICallback("NuiDevTool",function()
    triggerServerEvent('securenet:ban', 'nui devtools', ResourceName)
end)

local anahie = GetNumResourceMetadata("_cfx_internal", "client_script")
if anahie > 0 then
    triggerServerEvent('securenet:ban', 'lua executor', ResourceName)
end