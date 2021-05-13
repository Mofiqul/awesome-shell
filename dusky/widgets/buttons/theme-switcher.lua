local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local button_battery = create_button.circle_big(beautiful.battery_icon)

local label = button_battery:get_children_by_id("label")[1]

-- Detect if the system has a battery
local handle = io.popen(
	[=[
		bat_presence=$(ls /sys/class/power_supply | grep BAT)
		if [ -z "$bat_presence" ]; then
			echo "No battey detected"
		else 
			echo "Battery detected"
		fi
	]=]
)
local stdout = handle:read("*a")
handle:close()
--- If the system has battery then add battery widget to control center
if stdout:match("Battery detected") then
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
else
	label:set_text("NA")
end

return button_battery
