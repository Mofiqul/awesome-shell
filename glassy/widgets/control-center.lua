local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local battery_widget = require("widgets.panel.battery")
local volume_widget = require("widgets.panel.volume")
local network_indicator = require("widgets.panel.network")
local create_button = require("widgets.buttons.create-button")

-- Widget to show on panel
local control_widget = wibox.widget{
	{
		{
			{
				{
					volume_widget(),
					battery_widget(),
					network_indicator,
					spacing = dpi(4),
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.place
			},
			left = dpi(6),
			right = dpi(6),
			top = dpi(4),
			bottom = dpi(4),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		shape = beautiful.panel_button_shape,
		border_width = beautiful.btn_border_width,
		border_color = beautiful.border_button,
		widget = wibox.container.background
	},
	margins = dpi(2),
	widget = wibox.container.margin
}


local volume_slider = wibox.widget {
	require("widgets.volume-slider")(),
	margins = beautiful.widget_margin,
	widget = wibox.container.margin
}

local brightness_slider = wibox.widget {
	require("widgets.brightness-slider")(),
	margins = beautiful.widget_margin,
	widget = wibox.container.margin
}
--- Control buttons

local button_row_1= wibox.widget{
	require("widgets.buttons.dnd"),
	require("widgets.buttons.redshift"),
	require("widgets.buttons.airplane"),
	require("widgets.buttons.lock"),
	spacing = beautiful.widget_margin * 1.5,
	layout = wibox.layout.fixed.horizontal
}
local button_row_2 = wibox.widget{
	require("widgets.buttons.global-floating-mode"),
	require("widgets.buttons.screen-shot"),
	require("widgets.buttons.microphone"),
	require("widgets.buttons.software-update"),
	spacing = beautiful.widget_margin * 1.5,
	layout = wibox.layout.fixed.horizontal
}

-- Bluetooth and network buttons
local rounded_buttons= wibox.widget{
	require("widgets.buttons.bluetooth-button"),
	require("widgets.buttons.network-button"),
	spacing = beautiful.widget_margin * 1.5,
	layout = wibox.layout.fixed.horizontal
}

local control_buttons = wibox.widget{
	{
		{
			{
				rounded_buttons,
				widget = wibox.container.place
			},
			{
				button_row_1,
				widget = wibox.container.place
			},
			{
				button_row_2,
				widget = wibox.container.place
			},
			spacing = beautiful.widget_margin * 1.5,
			layout = wibox.layout.fixed.vertical
		},
		top = dpi(15),
		bottom = dpi(15),
		widget = wibox.container.margin
	},
	bg = beautiful.bg_normal,
	shape = beautiful.widget_shape,
	widget = wibox.container.background
}

-- power button
local power_button = create_button.small(beautiful.icon_system_power_off)

power_button:connect_signal("button::press", function (_, _, _, button)
	if button == 1 then 
		awesome.emit_signal("control-center::hide")
		awesome.emit_signal('module::exit_screen:show')
	end
end)


-- Session and user widget
local session_widget = function ()

	local widget_username = wibox.widget{
		text = 'Devops',
		font = "Ubuntu Bold 12",
		widget = wibox.widget.textbox
	}
	local widget_hostname = wibox.widget{
		text = '@localhost',
		font = "Ubuntu 10",
		widget = wibox.widget.textbox
	}
	-- Set hostname
	awful.spawn.easy_async(
		[=[ sh -c "hostnamectl | grep hostname | awk '{print $3}'"]=],
		function(stdout)
			widget_hostname:set_text("@" .. stdout)
		end
	)
	-- Set username
	awful.spawn.easy_async(
		"whoami",
		function(stdout)
			widget_username:set_text(stdout:gsub("^%l", string.upper):gsub("s+", ""))
		end
	)
	local user_widget = wibox.widget {
		{
			{
				{
					{
						image = beautiful.face_image,
						resize = true,
						forced_width = dpi(46),
						forced_height = dpi(46),
						widget = wibox.widget.imagebox
					},
					{
						{
							{
								widget_username,
								widget_hostname,
								expand = "none",
								layout = wibox.layout.flex.vertical
							},
							power_button,
							spacing = dpi(100),
							layout = wibox.layout.fixed.horizontal
						},
						widget =wibox.container.place
					},

					spacing = beautiful.widget_margin,
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.place
			},
			top = beautiful.widget_margin,
			bottom = beautiful.widget_margin,
			widget = wibox.container.margin
		},
		forced_height = dpi(60),
		widget = wibox.container.background
	}


	return user_widget
end

-- Function to split sting 
function str_split (inputstr, sep)
   if sep == nil then
           sep = "%s"
   end
   local t={}
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
           table.insert(t, str)
   end
   return t
end

-- Battery widget
local battery_widget = function ()
	local battery_percent = wibox.widget{
		text = "62%",
		font = "Ubuntu 10",
		forced_width = dpi(35),
		widget = wibox.widget.textbox
	}

	local battery_icon = wibox.widget{
		{
			image = beautiful.battery_icon,
			resize = true,
			forced_width = dpi(18),
			forced_height = dpi(18),
			widget = wibox.widget.imagebox
		},
		top = dpi(2),
		widget = wibox.container.margin
	}

	local battery_state = wibox.widget {
		text = "Discharging",
		font = "Ubuntu 10",
		valign = "left",
		forced_width = dpi(185),
		widget = wibox.widget.textbox
	}
	local battery = wibox.widget {
		{
			{
				battery_icon,
				battery_state,
				battery_percent,
				spacing = dpi(3),
				layout = wibox.layout.fixed.horizontal
			},
			widget = wibox.container.place
		},
		margins = beautiful.widget_margin,
		widget = wibox.container.margin
	}
	awful.widget.watch(
		[[sh -c "
		bat_state=$(acpi | awk '{print $3}')
		bat_percentage=$(acpi | awk '{print $4}')
		echo "$bat_state+$bat_percentage"
		"]],
		5,
		function (_, stdout)
			--battery_state:set_text(stdout:gsub('%\n', ''))
			local state = str_split(stdout:gsub(",", ""), "+")
			local status = state[1]
			local percent = state[2]
			battery_state:set_text(status:gsub("^%l", string.upper))
			battery_percent:set_text(percent)
		end
	)
	return battery
end

local battery_widget_wrapped = wibox.widget{
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
	shape = beautiful.widget_shape,
	battery_widget()

}

-- line separator
local horizontal_separator = wibox.widget {
	thikness = dpi(2),
	color = beautiful.bg_button,
	forced_width = dpi(200),
	forced_height  = dpi(1),
	widget = wibox.widget.separator
}

local slider_contols = wibox.widget{
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
	shape = beautiful.widget_shape,
	{
		layout = wibox.layout.fixed.vertical,
		volume_slider,
		horizontal_separator,
		brightness_slider
	}
}


local space = wibox.widget{
	widget = wibox.container.margin, 
	top = beautiful.widget_margin
}

local rows = { 
	layout = wibox.layout.fixed.vertical,
}
table.insert(rows, control_buttons)
table.insert(rows, space)
table.insert(rows, slider_contols)

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
	table.insert(rows, space)
	table.insert(rows, battery_widget_wrapped)
end

table.insert(rows, session_widget())

local control_popup = awful.popup{
	widget = {},
	ontop = true,
	shape = beautiful.widget_shape,
	bg = beautiful.bg_normal,
    visible = false,
	placement = function (w)
		awful.placement.bottom_right(w, {
			margins = {left = 0, top = 0, bottom = beautiful.wibar_height + dpi(5), right = dpi(5)}
		})
	end
}

control_popup:setup({
	widget = wibox.container.background,
	border_width = beautiful.widget_border_width,
	border_color = beautiful.border_button,
	shape = beautiful.widget_shape,
	rows
})

control_widget:buttons(
	gears.table.join(
		awful.button( {}, 1, function() 
			if control_popup.visible then 
				control_popup.visible = not control_popup.visible
			else
				control_popup.visible = true
			end
		end )
	)
)

awesome.connect_signal("control-center::hide", function ()
	control_popup.visible = false
end)

awesome.connect_signal("control-center::show", function ()
	control_popup.visible = true
end)

return control_widget
