local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")
local redshift = require("libs.redshift")

local initial_action = function(button)
	local background = button:get_children_by_id("background")[1]
	local label = button:get_children_by_id("label")[1]

	if redshift.state == 1 then
		background:set_bg(beautiful.bg_yellow)
		label:set_text("On")
	else
		background:set_bg(beautiful.bg_button)
		label:set_text("Off")
	end
end

local onclick_action = function ()
	redshift.toggle()
end


local redshift_button = create_button.circle_big(beautiful.icon_redshift)

redshift_button:connect_signal("button::press", function (self, _, _, button)
	if button == 1 then
		onclick_action()
		initial_action(self)
	end
end)

initial_action(redshift_button)

return redshift_button

