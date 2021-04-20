local setting = require("configurations.settings")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local network_indicator = function()

	local widget = wibox.widget {
		image = beautiful.wireless_connected_icon,
		resize = true,
		widget = wibox.widget.imagebox
	}

	gears.timer {
		timeout = 10,
		autostart = true,
		call_now = true,
		callback = function() 
			awful.spawn.easy_async_with_shell(
				[=[
				wireless="]=] .. tostring(setting.wlan_interface) .. [=["
				wired="]=] .. tostring(setting.lan_interface) .. [=["
				net="/sys/class/net/"
				wired_state="down"
				wireless_state="down"
				network_mode=""
				# Check network state based on interface's operstate value
				function check_network_state() {
					# Check what interface is up
					if [[ "${wireless_state}" == "up" ]];
					then
						network_mode='wireless'
					elif [[ "${wired_state}" == "up" ]];
					then
						network_mode='wired'
					else
						network_mode='No internet connection'
					fi
				}
				# Check if network directory exist
				function check_network_directory() {
					if [[ -n "${wireless}" && -d "${net}${wireless}" ]];
					then
						wireless_state="$(cat "${net}${wireless}/operstate")"
					fi
					if [[ -n "${wired}" && -d "${net}${wired}" ]]; then
						wired_state="$(cat "${net}${wired}/operstate")"
					fi
					check_network_state
				}
				# Start script
				function print_network_mode() {
					# Call to check network dir
					check_network_directory
					# Print network mode
					printf "${network_mode}"
				}
				print_network_mode
				]=],
				function(stdout)
					local mode = stdout:gsub('%\n', '')
					if stdout:match('No internet connection') then
						if mode == 'wireless' then
							widget:set_image(beautiful.wireless_disconnected_icon)
						else
							widget:set_image(beautiful.wired_disconnected_icon)
						end
					else
						if mode == 'wireless' then
							widget:set_image(beautiful.wireless_connected_icon)
						else
							widget:set_image(beautiful.wired_connected_icon)
						end
					end
				end
			)
		end
	}
	return widget
end
return wibox.widget {
	network_indicator(),
	widget = wibox.container.margin
}
