local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local network = require("module.network")
local setting = require("configurations.settings")
local default_apps = require("configurations.default-apps")


local widget_icon = wibox.widget{
	id = "icon",
	image = beautiful.wireless_connected_icon,
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
	text = "Wifi",
	font = "Ubuntu Bold 10",
	widget = wibox.widget.textbox
}
local text = wibox.widget{
	widget_name,
	status_text,
	layout = wibox.layout.fixed.vertical
}

local network_button = wibox.widget {
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

local update_button = function()
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
					network_button:set_bg(beautiful.bg_button)
					widget_name:set_text("Wifi")
					status_text:set_text("Offline")
				else
					network_button:set_bg(beautiful.bg_button)
					widget_name:set_text("Ethernet")
					status_text:set_text("Offline")
				end
			else
				if mode == 'wireless' then
					network_button:set_bg(beautiful.button_active_alt)
					widget_name:set_text("Wifi")
					network.set_widgettext_with_ssid(status_text)
				else
					network_button:set_bg(beautiful.button_active_alt)
					widget_name:set_text("Ethernet")
					status_text:set_text("Connected")
				end
			end
		end
	)
end


local old_cursor, old_wibox

network_button:connect_signal("mouse::enter", function(c)
	local wb = mouse.current_wibox
	old_cursor, old_wibox = wb.cursor, wb
	wb.cursor = "hand1"
end)
network_button:connect_signal("mouse::leave", function(c)
	if old_wibox then
    	old_wibox.cursor = old_cursor
    	old_wibox = nil
	end
end)



gears.timer {
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function ()
		update_button()
	end
}
update_button()

network_button:connect_signal(
	"button::press",
	function (_,_,_,button)
		if button == 1 then
			awful.spawn.easy_async_with_shell("rfkill list wifi", function (stdout)
				if stdout:match("Soft blocked: yes") then
					awful.spawn.single_instance("rfkill unblock wifi")
					status_text:set_text("Turning on...")
				else 
					awful.spawn.single_instance("rfkill block wifi")
					status_text:set_text("Turning off...")
				end
			end)
		end

		if button == 3 then 
			awful.spawn.single_instance(default_apps.network_manager)
		end
	end
)

return network_button
