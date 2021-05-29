local awful = require("awful")
local beautiful = require("beautiful")
local default_apps = require("configurations.default-apps")
local settings = require("configurations.settings")
local create_button = require("widgets.buttons.create-button")

local bluetooth_button = create_button.circle_big(beautiful.icon_bluetooth)

local background = bluetooth_button:get_children_by_id("background")[1]
local label = bluetooth_button:get_children_by_id("label")[1]


if settings.is_bluetooth_presence then
	awful.widget.watch(
		"rfkill list bluetooth",
		5,
		function(_, stdout)
			if stdout:match('Soft blocked: yes') then
				label:set_text('Off')
				background:set_bg(beautiful.bg_button)
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
							label:set_text('On')
							background:set_bg(beautiful.button_active)
						else 
							label:set_text(output)
							background:set_bg(beautiful.button_active)
						end
					end
				)
			end
		end
	)
else
	label:set_text('NA')
end

bluetooth_button:connect_signal(
	"button::press",
	function (_,_,_,button)
		if button == 1 then
			awful.spawn.easy_async_with_shell("rfkill list bluetooth", function (stdout)
				if stdout:match("Soft blocked: yes") then
					awful.spawn.single_instance("rfkill unblock bluetooth")
					label:set_text("Turning on...")
				else 
					awful.spawn.single_instance("rfkill block bluetooth")
					label:set_text("Turning off...")
				end
			end)
		end
		if button == 3 then
			awful.spawn.single_instance(default_apps.bluetooth_manager)
		end
	end
)

return bluetooth_button
