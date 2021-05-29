local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")
local default_apps = require("configurations.default-apps")

local software_update = create_button.circle_big(beautiful.icon_update_none)

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
	300,
	function (_, stdout)
		local background = software_update:get_children_by_id("background")[1]
		local label = software_update:get_children_by_id("label")[1]
		local update_count = stdout:gsub("%s+", "")

		if update_count ~= "0" then
			background:set_bg(beautiful.button_active)
			label:set_text(update_count)
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
			background:set_bg(beautiful.bg_button)
			label:set_text("None")
		end
	end
)

software_update:connect_signal("button::press", function (self, _, _, button)
	if button == 1 then
		awful.spawn.with_shell(default_apps.software_updater)
	end
end)
return software_update
