local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local initial_action = function (button) 
	awful.widget.watch("rfkill list all", 10, function(_, stdout) 
		if stdout:match('Soft blocked: yes') then
			button:set_bg(beautiful.button_active)
		else
			button:set_bg(beautiful.bg_button)
		end
	end)
end

local onclick_action = function()
	awful.spawn.easy_async("rfkill list all", function(stdout) 
		if stdout:match('Soft blocked: yes') then
			awful.spawn.with_shell("rfkill unblock all")
		else
			awful.spawn.with_shell("rfkill block all")
		end
	end)
end
local airplane_button = create_button.circle_big(beautiful.icon_airplane, initial_action, onclick_action)

return airplane_button
