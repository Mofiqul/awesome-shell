local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local onclick_action = function ()
	awful.spawn.with_shell("rm -rf $HOME/.config/awesome ; ln -s $HOME/Projects/awesome-config/dusky $HOME/.config/awesome")
	awesome.restart()

end

local lock_screen_button = create_button.circle_big(beautiful.icon_dark_mode, nil, onclick_action)

return lock_screen_button
