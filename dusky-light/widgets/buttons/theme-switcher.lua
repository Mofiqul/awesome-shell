local awful = require("awful")
local filesystem = require("gears").filesystem;
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")
local config_dir = filesystem.get_configuration_dir()
local onclick_action = function ()
	awful.spawn.easy_async_with_shell(config_dir .. "/scripts/dark-mode.sh", function (_)
		awesome.restart()
	end)

end

local lock_screen_button = create_button.circle_big(beautiful.icon_dark_mode, nil, onclick_action)

return lock_screen_button
