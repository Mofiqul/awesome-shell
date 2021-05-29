local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local initial_action = function (button)
	local background = button:get_children_by_id("background")[1]
	local label = button:get_children_by_id("label")[1]

	awful.spawn.easy_async_with_shell(
		[[sh -c amixer | grep 'Front Left: Capture' | awk -F' ' '{print $6}' | sed -e 's/\[//' -e 's/\]//']],
		function(stdout)
			if stdout:match('on') then
				background:set_bg(beautiful.button_active)
				label:set_text("In Use")
			else
				background:set_bg(beautiful.bg_button)
				label:set_text("Off")
			end
	end)
end

local onclick_action = function()
	awful.spawn.with_shell("amixer -D pulse sset Capture  toggle")
end

local microphone_button = create_button.circle_big(beautiful.icon_mic)


microphone_button:connect_signal("button::press", function (self, _, _, button)
	if button == 1 then
		onclick_action()
		initial_action(self)
	end
end)

initial_action(microphone_button)

return microphone_button
