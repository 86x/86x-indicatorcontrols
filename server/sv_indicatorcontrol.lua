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
RegisterServerEvent('86x-indicatorcontrols:svIndicatorLights')
AddEventHandler('86x-indicatorcontrols:svIndicatorLights', function(direction,status)
    local src = source
    local targetPlayer = -1 -- -1 means trigger the event for all players (update indicator status)
    TriggerClientEvent('86x-indicatorcontrols:setIndicatorLights',targetPlayer,src,direction,status)
end)
