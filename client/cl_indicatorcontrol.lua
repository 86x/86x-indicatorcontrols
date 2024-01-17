--    ,---.-,                            
--   '   ,'  '.                          
--  /   /      \                         
-- .   ;  ,/.  :    ,---.                
-- '   |  | :  ;   /     \               
-- '   |  ./   :  /    / '   ,--,  ,--,  
-- |   :       , .    ' /    |'. \/ .`|  
--  \   \     / '    / ;     '  \/  / ;  
--   ;   ,   '\ |   :  \      \  \.' /   
--  /   /      \;   |   ``.    \  ;  ;   
-- .   ;  ,/.  :'   ;      \  / \  \  \  
-- '   |  | :  ;'   |  .\  |./__;   ;  \ 
-- '   |  ./   :|   :  ';  :|   :/\  \ ; 
-- |   :      /  \   \    / `---'  `--`  
--  \   \   .'    `---`--`               
--   `---`-'  
-- ### 86x-indicatorcontrols by https://github.com/86x ###
-- 
local currentRes = GetCurrentResourceName()
local control_indicator_left = GetResourceMetadata(currentRes,"control_indicator_left",0)
local control_indicator_right = GetResourceMetadata(currentRes,"control_indicator_right",0)
local control_indicator_hazardlights = GetResourceMetadata(currentRes,"control_indicator_hazardlights",0)
local wasTrailerAttachedOnLastToggle = false

function isANumber(str)
    -- Checks whether or not the given string can be converted to a number
    if type(str) == "number" then
        return true
    end
    return tonumber(str) ~= nil and tostring(tonumber(str)) == str
end

if isANumber(control_indicator_left) 
  and isANumber(control_indicator_right) 
  and isANumber(control_indicator_hazardlights) 
  then
    -- Create a thread that runs forever and waits for key input from the user
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsIn(ped,false)
            
            if IsPedInAnyVehicle(ped,true) then
                if GetIsVehicleEngineRunning(veh) then
                    local isTrailerAttached,vehTrailer = GetVehicleTrailerVehicle(veh,vehTrailer)
                    if isTrailerAttached then
                        -- This might seem weird: 
                        -- The "engine" of an attached vehicle trailer must be running in order for the turn signals to flash
                        -- (I don't know why but I've tested it and this way it works)
                        -- The "engine" is regularly turned off by the game so it constantly needs to be set to "on" in this endless loop
                        SetVehicleEngineOn(vehTrailer,true,true,false)

                        -- If no trailer was attached during the last indicator toggle (but now a trailer is attached),
                        -- update the indicator status of the trailer (by calling the "update indicators on vehicle and trailer" function again)
                        -- to the status of the vehicle
                        if not wasTrailerAttachedOnLastToggle then
                            local isLeftIndicatorActive = false;
                            local isRightIndicatorActive = false;
                            local isHazardLightActive = false;

                            -- Get indicator state: 0 = off, 1 = left, 2 = right, 3 = both
                            local indicatorState = GetVehicleIndicatorLights(veh)
                            if indicatorState == 1 then
                                isLeftIndicatorActive = true
                            elseif indicatorState == 2 then
                                isRightIndicatorActive = true
                            elseif indicatorState == 3 then
                                isHazardLightActive = true
                                isLeftIndicatorActive = true
                                isRightIndicatorActive = true
                            end

                            -- This additional function (svSetVehIndicatorLights) is required because the transmit of the status 
                            -- "yes, a trailer is attached now to the vehicle" might take longer than sending this update to all 
                            -- players which results in some cases in not all players being able to see the updated indicator 
                            -- status on trailers.
                            TriggerServerEvent('86x-indicatorcontrols:svSetNetIndicatorLights',VehToNet(vehTrailer),1,isLeftIndicatorActive)
                            TriggerServerEvent('86x-indicatorcontrols:svSetNetIndicatorLights',VehToNet(vehTrailer),0,isRightIndicatorActive)
                            wasTrailerAttachedOnLastToggle = true
                        end
                    end
                end
            end

            -- Handle key press event for left indicator
            if IsControlJustReleased(0,tonumber(control_indicator_left)) then
                if IsPedInAnyVehicle(ped,true) then
                    TriggerEvent('86x-indicatorcontrols:toggle','left')
                end
            end

            -- Handle key press event for right indicator
            if IsControlJustReleased(0,tonumber(control_indicator_right)) then
                if IsPedInAnyVehicle(ped,true) then
                    TriggerEvent('86x-indicatorcontrols:toggle','right')
                end
            end

            -- Handle key press event for hazard lights
            if IsControlJustReleased(0,tonumber(control_indicator_hazardlights)) then
                if IsPedInAnyVehicle(ped,true) then
                    TriggerEvent('86x-indicatorcontrols:toggle','hazardlights')
                end
            end
        end
    end)
  else
    print("Unable to start 86x-indicatorcontrols because of a malformed resource manifest.")
end


RegisterNetEvent('86x-indicatorcontrols:toggle')
AddEventHandler('86x-indicatorcontrols:toggle', function(direction)
    Citizen.CreateThread(function()
        -- Get the current player ped
        local ped = GetPlayerPed(-1)

        -- Check if the ped is currently inside of a vehicle
        if IsPedInAnyVehicle(ped,true) then
            local veh = GetVehiclePedIsIn(ped,false)

            local isLeftIndicatorActive = false;
            local isRightIndicatorActive = false;
            local isHazardLightActive = false;

            -- Get indicator state: 0 = off, 1 = left, 2 = right, 3 = both
            local indicatorState = GetVehicleIndicatorLights(veh)
            if indicatorState == 1 then
                isLeftIndicatorActive = true
            elseif indicatorState == 2 then
                isRightIndicatorActive = true
            elseif indicatorState == 3 then
                isHazardLightActive = true
                isLeftIndicatorActive = true
                isRightIndicatorActive = true
            end

            -- Check if the user is in the drivers seat (-1)
            if GetPedInVehicleSeat(veh,-1) == ped then
                if direction == 'left' then
                    -- If hazard lights are on, ignore this request
                    if not isHazardLightActive then
                        -- Toggle left indicator
                        TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',1,not isLeftIndicatorActive)
                        -- Turn right indicator off if it is on currently
                        if isRightIndicatorActive then
                            TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',0,false)
                        end
                    else
                        print("Ignoring left indicator toggle because hazard lights are on.")
                    end
                elseif direction == 'right' then
                    -- If hazard lights are on, ignore this request
                    if not isHazardLightActive then
                        -- Toggle right indicator
                        TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',0,not isRightIndicatorActive)
                        -- Turn left indicator off if it is on currently
                        if isLeftIndicatorActive then
                            TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',1,false)
                        end
                    else
                        print("Ignoring right indicator toggle because hazard lights are on.")
                    end
                elseif direction == 'hazardlights' then
                    -- Toggle "hazard" lights (both indicators at once)
                    if isHazardLightActive then
                        TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',1,false)
                        TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',0,false)
                    else
                        TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',1,true)
                        TriggerServerEvent('86x-indicatorcontrols:svIndicatorLights',0,true)
                    end
                end
            end

            -- Check if a trailer is currently attached and save this information for later use
            local isTrailerAttached,vehTrailer = GetVehicleTrailerVehicle(veh,vehTrailer)
            wasTrailerAttachedOnLastToggle = isTrailerAttached
        end
    end)
end)


RegisterNetEvent('86x-indicatorcontrols:setIndicatorLights')
AddEventHandler('86x-indicatorcontrols:setIndicatorLights',function(playerId,direction,status)
    Citizen.CreateThread(function()
        local veh = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerId)),false)
        local isTrailerAttached,vehTrailer = GetVehicleTrailerVehicle(veh,vehTrailer)
        if direction == 0 or direction == 1 then
            SetVehicleIndicatorLights(veh,direction,status)
            if isTrailerAttached then
                -- Set indicators of trailer to the same value as the vehicle
                SetVehicleIndicatorLights(vehTrailer,direction,status)
            end
        else
            print("Malformed indicator direction")
        end
    end)
end)


RegisterNetEvent('86x-indicatorcontrols:setNetIndicatorLights')
AddEventHandler('86x-indicatorcontrols:setNetIndicatorLights',function(vehNet,direction,status)
    Citizen.CreateThread(function()
        local veh = NetToVeh(vehNet)
        local isTrailerAttached,vehTrailer = GetVehicleTrailerVehicle(veh,vehTrailer)
        if direction == 0 or direction == 1 then
            SetVehicleIndicatorLights(veh,direction,status)
            if isTrailerAttached then
                -- Set indicators of trailer to the same value as the vehicle
                SetVehicleIndicatorLights(vehTrailer,direction,status)
            end
        else
            print("Malformed indicator direction")
        end
    end)
end)
