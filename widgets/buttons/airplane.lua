local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local initial_action = function (button)
	local background = button:get_children_by_id("background")[1]
	local label = button:get_children_by_id("label")[1]

	awful.spawn.easy_async_with_shell("rfkill list all",function(stdout)
		if stdout:match('Soft blocked: yes') then
			background:set_bg(beautiful.button_active)
			label:set_text("On")
		else
			background:set_bg(beautiful.bg_button)
			label:set_text("Off")
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

local airplane_button = create_button.circle_big(beautiful.icon_airplane)


airplane_button:connect_signal("button::press", function (self, _, _, button)
	if button == 1 then
		onclick_action()
		initial_action(self)
	end
end)

initial_action(airplane_button)

return airplane_button
