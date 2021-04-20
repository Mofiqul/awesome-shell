local naughty = require("naughty")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")


local initial_action = function(button)
	if naughty.suspended then
		button:set_bg(beautiful.button_active)
	else
		button:set_bg(beautiful.bg_button)
	end
end

local onclick_action = function ()
	naughty.suspended = not naughty.suspended
end


local dnd_button = create_button.circle_big(beautiful.icon_bell, initial_action, onclick_action)

return dnd_button

