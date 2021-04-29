local awful = require("awful")
local beautiful = require("beautiful")
local filesystem = require("gears").filesystem
local create_button = require("widgets.buttons.create-button")
local config_dir = filesystem.get_configuration_dir()
local helpers = require("libs.helpers")

local onclick_action = function ()
	awful.spawn.with_shell(config_dir .. "scripts/light-mode.sh")
	helpers.sleep(.2)
	awesome.restart()
end

local lock_screen_button = create_button.circle_big(beautiful.icon_dark_mode, nil, onclick_action)

return lock_screen_button
