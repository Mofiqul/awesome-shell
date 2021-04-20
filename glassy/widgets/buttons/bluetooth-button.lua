local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local default_apps = require("configurations.default-apps")
local settings = require("configurations.settings")

local widget_icon = wibox.widget{
	id = "icon",
	image = beautiful.icon_bluetooth,
	forced_width = 26,
	forced_height = 26,
	widget = wibox.widget.imagebox
}

local status_text = wibox.widget{
	text = "Off",
	font = "Ubuntu 8",
	widget = wibox.widget.textbox
}
local widget_name = wibox.widget{
	text = "Bluetooth",
	font = "Ubuntu Bold 10",
	widget = wibox.widget.textbox
}
local text = wibox.widget{
	widget_name,
	status_text,
	layout = wibox.layout.fixed.vertical
}

local bluetooth_button = wibox.widget {
	{
		{
			widget_icon,
			text,
			spacing = dpi(4),
			layout = wibox.layout.fixed.horizontal
		},
		top = dpi(12),
		bottom = dpi(12),
		left = dpi(10),
		right = dpi(10),
		widget = wibox.container.margin
	},
	forced_width = dpi(115),
	shape = gears.shape.rounded_rect,
	bg = beautiful.bg_button,
	shape_border_color = beautiful.border_button,
	shape_border_width = dpi(1),
	widget = wibox.container.background
}

local old_cursor, old_wibox

bluetooth_button:connect_signal("mouse::enter", function(c)
	local wb = mouse.current_wibox
	old_cursor, old_wibox = wb.cursor, wb
	wb.cursor = "hand1"
end)
bluetooth_button:connect_signal("mouse::leave", function(c)
	if old_wibox then
    	old_wibox.cursor = old_cursor
    	old_wibox = nil
	end
end)


if settings.is_bluetooth_presence then
	awful.widget.watch(
		"rfkill list bluetooth",
		5,
		function(_, stdout)
			if stdout:match('Soft blocked: yes') then
				status_text:set_text('Off')
				bluetooth_button:set_bg(beautiful.bg_button)
			else
				awful.spawn.easy_async_with_shell(
					[=[
						devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)

						echo "$devices_paired"| while read -r line; do
							device_info=$(bluetoothctl info "$line")
							if echo "$device_info" | grep -q "Connected: yes"; then
								device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)
								echo "$device_alias"
								break
							fi
						done

					]=],
					function (stdout)
						local output = stdout:gsub("%s+", " ")
						if output == '' or  output == nil then
							status_text:set_text('On')
							bluetooth_button:set_bg(beautiful.button_active)
						else 
							status_text:set_text(output)
							bluetooth_button:set_bg(beautiful.button_active)
						end
					end
				)
			end
		end
	)
else
	status_text:set_text('NA')
end




bluetooth_button:connect_signal(
	"button::press",
	function (_,_,_,button)
		if button == 1 then
			awful.spawn.easy_async_with_shell("rfkill list bluetooth", function (stdout)
				if stdout:match("Soft blocked: yes") then
					awful.spawn.single_instance("rfkill unblock bluetooth")
					status_text:set_text("Turning on...")
				else 
					awful.spawn.single_instance("rfkill block bluetooth")
					status_text:set_text("Turning off...")
				end
			end)
		end
		if button == 3 then
			awful.spawn.single_instance(default_apps.bluetooth_manager)
		end
	end
)

return bluetooth_button
