local naughty = require("naughty")
local setting = require("configurations.settings")
local awful = require("awful")
local network = {}



function network.notify(message, title, app_name, icon)
	naughty.notification({
		message = message,
		title = title,
		app_name = app_name,
		icon = icon
	})
end


-- Create wireless connection notification
function network.notify_wirless_connected(essid)
	local message = 'You are now connected to <b>\"' .. essid .. '\"</b>'
	local title = 'Connection Established'
	local app_name = 'System Notification'
	local icon = setting.icons.wifi_icon
	network.notify(message, title, app_name, icon)
end

-- Create wired connection notification
function network.notify_wired_connected()
	local message = 'Connected to internet with <b>\"' .. setting.lan_interface .. '\"</b>'
	local title = 'Connection Established'
	local app_name = 'System Notification'
	local icon = setting.icons.wlan_icon
	network.notify(message, title, app_name, icon)
end

function network.notify_wireless_disconnected ()
	local message = 'Wi-Fi network has been disconnected'
	local title = 'Connection Disconnected'
	local app_name = 'System Notification'
	local icon = setting.icons.wifi_icon
	network.notify(message, title, app_name, icon)
end

function network.notify_wired_disconnected()
	local message = 'Ethernet network has been disconnected'
	local title = 'Connection Disconnected'
	local app_name = 'System Notification'
	local icon = setting.icons.wlan_icon
	network.notify(message, title, app_name, icon)
end


-- Get wifi essid
function network.get_essid()
	return awful.spawn.easy_async_with_shell(
		[[
		iw dev ]] .. setting.wlan_interface .. [[ link
		]],
		function(stdout)
			local essid = stdout:match('SSID: (.-)\n') or 'N/A'
			return essid
		end
	)
end

function network.set_widgettext_with_ssid(widget)
	return awful.spawn.easy_async_with_shell(
		[[
		iw dev ]] .. setting.wlan_interface .. [[ link
		]],
		function(stdout)
			local essid = stdout:match('SSID: (.-)\n') or 'N/A'
			widget:set_text(essid)
		end
	)
end

function network.update_button(widget, widget_i, widget_s)
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
			network.mode = stdout:gsub('%\n', '')
			if stdout:match('No internet connection') then
				if network.mode == 'wireless' then
					widget:set_bg(colors.bg_button)
					widget_i:set_text("Wifi")
					widget_s:set_text("Offline")
				else 
					widget:set_bg(colors.bg_button)
					widget_i:set_text("Ethernet")
					widget_s:set_text("Offline")
				end
			else
				if network.mode == 'wireless' then
					widget:set_bg(colors.bg_success)
					widget_i:set_text("Wifi")
					network.set_widgettext_with_ssid(widget_s)
				else
					widget:set_bg(colors.bg_button)
					widget_i:set_text("Ethernet")
					widget_s:set_text("Connected")
				end
			end
		end
	)
end

function network.check_network_mode ()
	if not network.is_connected then
		if network.mode == "wireless" then
			network.notify_wirless_diconnected()
		else
			network.notify_wired_disconnected()
		end
	elseif network.mode == 'wireless' then
		network.notify_wirless_connected(network.get_essid())
	elseif network.mode('wired') then
		network.notify_wired_connected()
	end
end

return network
