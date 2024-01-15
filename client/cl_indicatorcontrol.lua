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

            -- Handle key press event for left indicator
            if IsControlJustReleased(0,tonumber(control_indicator_left)) then
                if IsPedInAnyVehicle(GetPlayerPed(-1),true) then
                    TriggerEvent('86x-indicatorcontrols:toggle','left')
                end
            end

            -- Handle key press event for right indicator
            if IsControlJustReleased(0,tonumber(control_indicator_right)) then
                if IsPedInAnyVehicle(GetPlayerPed(-1),true) then
                    TriggerEvent('86x-indicatorcontrols:toggle','right')
                end
            end

            -- Handle key press event for hazard lights
            if IsControlJustReleased(0,tonumber(control_indicator_hazardlights)) then
                if IsPedInAnyVehicle(GetPlayerPed(-1),true) then
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
        end
    end)
end)


RegisterNetEvent('86x-indicatorcontrols:setIndicatorLights')
AddEventHandler('86x-indicatorcontrols:setIndicatorLights',function(playerId,direction,status)
    local veh = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerId)),false)
    if direction == 0 or direction == 1 then
        SetVehicleIndicatorLights(veh,direction,status)
    else
        print("Malformed indicator direction")
    end
end)
