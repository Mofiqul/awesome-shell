local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local create_button = require("widgets.buttons.create-button")
local btn_container = require("widgets.clickable-container")
local btn_bg_container = require("widgets.button-active-container")

local network_widget = require("widgets.buttons.network-button")
local battery_widget = require("widgets.buttons.battery")
local volume_widget = require("widgets.volume-slider-and-indicator")

local control_center = function (s)
	-- Widget to show on panel
	local control_widget = wibox.widget{
		{
			{
				{
					{
						{
							network_widget.panel_indicator,
							volume_widget.indicator,
							battery_widget.indicator,
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
				id = "background",
				widget = btn_bg_container
			},
			margins = dpi(2),
			widget = wibox.container.margin
		},
		widget = btn_container
	}

	--- Control buttons
	local button_row_1= wibox.widget{
		network_widget.network_button,
		require("widgets.buttons.dnd"),
		require("widgets.buttons.redshift"),
		require("widgets.buttons.airplane"),
		battery_widget.button,
		spacing = beautiful.widget_margin,
		layout = wibox.layout.fixed.horizontal
	}
	local button_row_2 = wibox.widget{
		require("widgets.buttons.bluetooth-button"),
		require("widgets.buttons.global-floating-mode"),
		require("widgets.buttons.screen-shot")(s),
		require("widgets.buttons.microphone"),
		require("widgets.buttons.software-update"),
		spacing = beautiful.widget_margin,
		layout = wibox.layout.fixed.horizontal
	}


	local control_buttons = wibox.widget{
		{
			{
				button_row_1,
				widget = wibox.container.place
			},
			{
				button_row_2,
				widget = wibox.container.place
			},
			spacing = beautiful.widget_margin * 2 ,
			layout = wibox.layout.fixed.vertical
		},
		top = dpi(15),
		bottom = dpi(15),
		widget = wibox.container.margin
	}

	-- power button
	local power_button = create_button.small(beautiful.icon_system_power_off)

	power_button:connect_signal("button::press", function (_, _, _, button)
		if button == 1 then 
			awesome.emit_signal("control-center::hide")
			awesome.emit_signal('module::exit_screen:show')
		end
	end)

	local logout_button = wibox.widget{
		widget = btn_container,
		{
			widget = wibox.container.background,
			bg = beautiful.bg_button,
			shape = gears.shape.rounded_bar,
			{
				widget = wibox.container.margin,
				margins = {top = dpi(9), left = dpi(16), bottom = dpi(9), right = dpi(16)},
				{
					widget = wibox.widget.textbox,
					font = beautiful.font_large,
					text = "Sign out"
				}
			}
		}
	}

	logout_button:connect_signal("button::press", function (_, _, _, button)
		if button == 1 then
			awesome.quit()
		end
	end)

	-- Session and user widget
	local session_widget = function ()

		local widget_username = wibox.widget{
			text = 'Devops',
			font = beautiful.font_large_bold,
			valign = "center",
			widget = wibox.widget.textbox
		}
		-- Set username
		awful.spawn.easy_async(
			"whoami",
			function(stdout)
				widget_username:set_text(stdout:gsub("^%l", string.upper):gsub("%s+", ""))
			end
		)
		local user_widget = wibox.widget {
			{	{
					{
						image = beautiful.face_image,
						resize = true,
						forced_width = dpi(42),
						forced_height = dpi(42),
						clip_shape = gears.shape.circle,
						widget = wibox.widget.imagebox
					},
					widget_username,
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal
				},
				nil,
				{
					logout_button,
					{
						power_button,
						widget = wibox.container.place
					},
					spacing = dpi(6),
					layout = wibox.layout.fixed.horizontal
				},
				layout = wibox.layout.align.horizontal
			},
			left = dpi(8),
			right = dpi(8),
			bottom = dpi(10),
			widget = wibox.container.margin
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


	local slider_contols = wibox.widget{
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(10),
		volume_widget.slider,
		require("widgets.brightness-slider"),
	}


	local space = wibox.widget{
		widget = wibox.container.margin, 
		top = dpi(10)
	}

	local rows = { 
		layout = wibox.layout.fixed.vertical,
	}
	table.insert(rows, session_widget())
	table.insert(rows, control_buttons)
	table.insert(rows, space)
	table.insert(rows, slider_contols)

	local notification_center = wibox.widget{
		require("widgets.noti-center"),
		top = dpi(20),
		widget = wibox.container.margin
	}
	table.insert(rows, notification_center)

	
	local popup_height = s.geometry.height - (beautiful.wibar_height + dpi(10))
	local control_popup = awful.popup{
		widget = {},
		ontop = true,
		bg = "#00000000",
		visible = false,
		screen = s,
		placement = function (w)
			awful.placement.bottom_right(w, {
				margins = {left = 0, top = 5, bottom = beautiful.wibar_height + dpi(5), right = dpi(5)}
			})
		end
	}

	control_popup:setup({
		widget = wibox.container.background,
		bg = beautiful.bg_normal,
		shape = beautiful.widget_shape,
		forced_height = popup_height,
		{
			rows,
			widget = wibox.container.margin,
			top = dpi(40),
			bottom = dpi(30),
			left = dpi(25),
			right = dpi(25)
		}
	})

	control_widget:connect_signal("button::press", function (self, _, _, button)
		if button == 1 then
				local background_widget = self:get_children_by_id('background')[1]
				if control_popup.visible then
					control_popup.visible = not control_popup.visible
					background_widget.set_inactive()
				else
					control_popup.visible = true
					background_widget.set_active()
				end
		end
	end)


	awesome.connect_signal("control-center::hide", function ()
		control_popup.visible = false
	end)

	awesome.connect_signal("control-center::show", function ()
		control_popup.visible = true
	end)

	return control_widget
end


return control_center
