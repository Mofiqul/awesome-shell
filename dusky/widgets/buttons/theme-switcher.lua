local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")


local button_battery = create_button.circle_big(beautiful.battery_icon)


local label = button_battery:get_children_by_id("label")[1]

awful.widget.watch(
	[[sh -c "
	bat_percentage=$(acpi | awk '{print $4}')
	echo "$bat_percentage"
	"]],
	5,
	function (_, stdout)
		local percent = stdout:gsub(",", ""):gsub("%s+", "")
		label:set_text(percent)
	end
)

return button_battery
