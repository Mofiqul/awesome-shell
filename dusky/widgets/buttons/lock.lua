local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")
local default_apps = require("configurations.default-apps")
local helpers = require("libs.helpers")

local onclick_action = function ()
	awesome.emit_signal("control-center::hide")
	helpers.sleep(.2)
	awful.spawn.with_shell(default_apps.lock_screen)
end

local lock_screen_button = create_button.circle_big(beautiful.icon_lock, nil, onclick_action)

return lock_screen_button
