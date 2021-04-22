local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")
local default_apps = require("configurations.default-apps")

local software_update = create_button.circle_big(beautiful.icon_update_none, nil, function ()
	awful.spawn.with_shell(default_apps.software_updater)
end)

local naughty = require("naughty")

local notification_sent = 0


local action_update_now = naughty.action{
	name = "Update now"
}

action_update_now:connect_signal("invoked", function ()
	awful.spawn.with_shell(default_apps.software_updater)
end)


awful.widget.watch(
	[[sh -c "pacman -Qu | wc -l"]],
	10,
	function (_, stdout)
		if stdout:gsub("%s+", "") ~= "0" then
			software_update:set_bg(beautiful.button_active)
			if notification_sent == 0 then
				naughty.notification({
					title = "New software updates",
					text = "There are new updates available",
					icon = beautiful.icon_noti_info,
					timeout = 10,
					app_name = "Software Updater",
					actions = {
						action_update_now,
						naughty.action {
							name = "Maybe later"
						}
					}
				})
				notification_sent = 1
			end
		else
			software_update:set_bg(beautiful.bg_button)
		end
	end
)

return software_update
