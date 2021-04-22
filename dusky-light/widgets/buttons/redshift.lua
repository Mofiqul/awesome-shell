local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")
local redshift = require("libs.redshift")

local initial_action = function(button)
	if redshift.state == 1 then
		button:set_bg(beautiful.button_active)
	else
		button:set_bg(beautiful.bg_button)
	end
end

local onclick_action = function ()
	redshift.toggle()
end


local redshift_button = create_button.circle_big(beautiful.icon_redshift, initial_action, onclick_action)

return redshift_button

