fx_version 'cerulean'
game 'gta5'

author 'https://github.com/86x - eighty-six-x'
description 'Allows players to control the indicators of vehicles that support this feature.'
version '1.0.0'

client_script 'client/cl_indicatorcontrol.lua'

-- Modify the values below to change the control buttons
-- Lines starting with -- are a comment and are not considered by the script
-- Example controls:
-- ---------------------------------------------------------
-- | Code| Base Game function    |  Keyboard   | Controller |
-- | 172 | INPUT_CELLPHONE_UP    |  ARROW UP   | DPAD UP    |
-- | 174 | INPUT_CELLPHONE_LEFT  |  ARROW LEFT | DPAD LEFT  |
-- | 175 | INPUT_CELLPHONE_RIGHT |  ARROWRIGHT | DPAD RIGHT |
-- ---------------------------------------------------------
-- Find more values here: https://docs.fivem.net/docs/game-references/controls/
-- *** IMPORTANT *** Make sure to put the keycodes in quotes. *** IMPORTANT ***
-- Example:
-- control_indicator_left "174"
-- control_indicator_right "175"
-- control_indicator_hazardlights "172"
control_indicator_left "174"
control_indicator_right "175"
control_indicator_hazardlights "172"
