local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local button_battery = create_button.circle_big(beautiful.battery_icon)

local label = button_battery:get_children_by_id("label")[1]
local icon = button_battery:get_children_by_id("icon")[1]

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
		bat_state=$(acpi | awk '{print $3}')
		bat_percentage=$(acpi | awk '{print $4}')
		echo "$bat_state+$bat_percentage"
		"]],
		5,
		function (_, stdout)
			local state = str_split(stdout:gsub(",", ""), "+")
			local status = state[1]:gsub("%s+", "")
			local percent = state[2]
			label:set_text(percent:gsub("%s+", ""))
			if status == 'Charging' then
				icon.image = beautiful.battery_icon_charging
				icon:emit_signal("widget::redraw_needed")
			end
		end
	)
else
	label:set_text("AC")
	icon.image = beautiful.icon_ac
	icon:emit_signal("widget::redraw_needed")
end

return button_battery
