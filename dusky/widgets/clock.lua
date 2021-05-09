local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')
local btn_bg_container = require("widgets.button-active-container")

local create_clock = function()

	local clock_format = nil
	clock_format = '<span font="Ubuntu 12">%I:%M:%S %p</span>'

	local clock_widget = wibox.widget.textclock(
		clock_format,
		1
	)

	clock_widget = wibox.widget {
		{	{
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
				id = "background",
				widget = btn_bg_container
			},
			margins = dpi(2),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}


	local calendar = awful.popup{
		ontop = true,
		visible = false,
		bg = "#00000000",
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
			border_width = beautiful.widget_border_width,
			border_color = beautiful.border_normal,
			bg = beautiful.bg_normal,
			shape = beautiful.widget_shape,
			widget = wibox.container.background
		}
	}

	clock_widget:connect_signal("button::press", function (self, _, _, button)
		if button == 1 then
				local background_widget = self:get_children_by_id('background')[1]
				if calendar.visible then
					calendar.visible = not calendar.visible
					background_widget.set_inactive()
				else
					calendar.visible = true
					background_widget.set_active()
				end
		end
	end)

	awesome.connect_signal("calendar::show", function ()
		calendar.visible = true
	end)

	awesome.connect_signal("calendar::hide", function ()
		calendar.visible = false
	end)

	return clock_widget
	
end

return create_clock

