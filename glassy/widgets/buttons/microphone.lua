local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local initial_action = function (button) 
	awful.widget.watch(
		[[sh -c "amixer | grep 'Front Left: Capture' | awk -F' ' '{print $6}' | sed -e 's/\[//' -e 's/\]//'"]], 
		10, 
		function(_, stdout)
			--naughty.notification({text = stdout})
			if stdout:match('on') then
				button:set_bg(beautiful.button_active)
			else
				button:set_bg(beautiful.bg_button)
			end
	end)
end

local onclick_action = function()
	awful.spawn.with_shell("amixer -D pulse sset Capture  toggle")
end

local microphone_button = create_button.circle_big(beautiful.icon_mic, initial_action, onclick_action)

return microphone_button
