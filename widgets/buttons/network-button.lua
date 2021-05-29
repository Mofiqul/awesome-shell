local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local network = require("module.network")
local setting = require("configurations.settings")
local default_apps = require("configurations.default-apps")
local create_button = require("widgets.buttons.create-button")

-- Network button for control center
local network_button = create_button.circle_big(beautiful.wireless_connected_icon)
local background = network_button:get_children_by_id("background")[1]
local label = network_button:get_children_by_id("label")[1]

-- Panel network indicator
local panel_indicator = wibox.widget {
	image = beautiful.wireless_connected_icon,
	resize = true,
	forced_height = beautiful.wibar_icon_size,
	forced_width = beautiful.wibar_icon_size,
	widget = wibox.widget.imagebox
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
					background:set_bg(beautiful.bg_button)
					label:set_text("Offline")
					panel_indicator:set_image(beautiful.wireless_disconnected_icon)
				else
					background:set_bg(beautiful.bg_button)
					label:set_text("Offline")
					panel_indicator:set_image(beautiful.wired_disconnected_icon)
				end
			else
				if mode == 'wireless' then
					background:set_bg(beautiful.button_active_alt)
					network.set_widgettext_with_ssid(label)
					panel_indicator:set_image(beautiful.wireless_connected_icon)
				else
					background:set_bg(beautiful.button_active_alt)
					label:set_text("Connected")
					panel_indicator:set_image(beautiful.wired_connected_icon)
				end
			end
		end
	)
end

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
					label:set_text("Turning on...")
				else
					awful.spawn.single_instance("rfkill block wifi")
					label:set_text("Turning off...")
				end
			end)
		end

		if button == 3 then
			awful.spawn.single_instance(default_apps.network_manager)
		end
	end
)

local module = {}
module.network_button = network_button
module.panel_indicator = panel_indicator

return module
