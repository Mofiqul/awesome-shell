local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local create_button = require("widgets.buttons.create-button")

-- Battery button for control center
local button_battery = create_button.circle_big(beautiful.battery_icon)
local label = button_battery:get_children_by_id("label")[1]
local icon = button_battery:get_children_by_id("icon")[1]

-- Battery indicator for panel
local battery_panel_indicator = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true,
	forced_height = beautiful.wibar_icon_size,
	forced_width = beautiful.wibar_icon_size
}

local function show_battery_notification(msg, title, icon, timeout)
    naughty.notification ({
		app_name = "Power Manager",
        icon = icon,
        text = msg,
        title = title,
        timeout = timeout or 20, -- show the warning for a longer time
    })
end

local last_battery_check = os.time()

local update_status = function ()
	awful.spawn.easy_async_with_shell(
		"acpi",
		function (stdout)
			local state = str_split(stdout:gsub(",", ""), " ")
			local status = state[3]:gsub("%s+", "")
			local charge = ''
			-- This is required because sometime bad battery show "Not Charging"
			if status == "Not" then
				charge = state[5]:gsub("%%", "")
			else
				charge = state[4]:gsub("%%", "")
			end
			label:set_text(charge:gsub("%s+", "") .. "%")

			if status == 'Charging' then
				icon.image = beautiful.battery_icon_charging
				icon:emit_signal("widget::redraw_needed")
				battery_panel_indicator:set_image(beautiful.battery_icon_charging)
			else
				icon.image = beautiful.battery_icon
				icon:emit_signal("widget::redraw_needed")
				battery_panel_indicator:set_image(beautiful.battery_icon)
			end

			charge = tonumber(charge)
			if (charge >= 0 and charge < 15) then
				-- Checking only for "Discharging" because sometimes staus can be "Unknown" and "Not changing"
				-- and dont want to give notification for those status
				if status ~= "Charging" and os.difftime(os.time(), last_battery_check) > 300 then
					last_battery_check = os.time()
					local msg = "Battery is criticaly low, save your work or plug adapter"
					local title = "<b>Battery criticaly low</b>"
					show_battery_notification(msg, title, beautiful.icon_bat_caution, 20)
				end
			end
		end
	)
end


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

	gears.timer {
		timeout = 5,
		autostart = true,
		call_now = true,
		callback = function ()
			update_status()
		end
	}
else
	label:set_text("AC")
	icon.image = beautiful.icon_ac
	icon:emit_signal("widget::redraw_needed")
	battery_panel_indicator:set_image(beautiful.icon_ac)
end

update_status()

local module = {}
module.button = button_battery
module.indicator = battery_panel_indicator

return module
