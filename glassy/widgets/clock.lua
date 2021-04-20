local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')

local create_clock = function()

	local clock_format = nil
	clock_format = '<span font="Ubuntu 12">%I:%M:%S %p</span>'

	local clock_widget = wibox.widget.textclock(
		clock_format,
		1
	)

	clock_widget = wibox.widget {
		{
			{
				{
					{
						clock_widget,
						widget = wibox.container.margin
					},
					widget = clickable_container
				},
				top = dpi(2),
				bottom = dpi(2),
				left = dpi(6),
				right = dpi(6),
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

	clock_widget:connect_signal(
		'mouse::enter',
		function()
			local w = mouse.current_wibox
			if w then
				old_cursor, old_wibox = w.cursor, w
				w.cursor = 'hand1'
			end
		end
	)

	clock_widget:connect_signal(
		'mouse::leave',
		function()
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end
	)

	local calendar = awful.popup{
		ontop = true,
		visible = false,
		shape = beautiful.widget_shape,
		placement = function (w)
			awful.placement.bottom_right(w, {
				margins = {left = 0, top = 0, bottom = beautiful.wibar_height + dpi(5), right = dpi(5)}
			})
		end,
		widget = {
			{
				require("widgets.calender"),
				margins = beautiful.widget_margin,
				widget = wibox.container.margin,
			},
			border_width = dpi(1),
			border_color = beautiful.border_button,
			shape = beautiful.widget_shape,
			widget = wibox.container.background
		}
	}

	clock_widget:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				function()
					if calendar.visible then
						calendar.visible = not calendar.visible
					else 
						calendar.visible = true
						--calendar:move_next_to(mouse.current_widget_geometry)
					end
				end
			)
		)
	)

	awesome.connect_signal("calendar::show", function ()
		calendar.visible = true
	end)

	awesome.connect_signal("calendar::hide", function ()
		calendar.visible = false
	end)

	return clock_widget
	
end

return create_clock

