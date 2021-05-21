local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widgets.clickable-container')
local btn_bg_container = require("widgets.button-active-container")

local create_clock = function()

	local clock_format = nil
	clock_format = '<span font="Ubuntu 12">%I:%M %p</span>'

	local clock_widget = wibox.widget.textclock(clock_format, 60)

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


	local s =  awful.screen.focused()
	local popup_height = s.geometry.height - (beautiful.wibar_height + dpi(10))
	local time_format = "<span font='Ubuntu light 36'> %I:%M </span> "
	local date_formate = "<span font='Ubuntu bold 12'> %A, %B, %d </span>"
	local time = wibox.container.place(wibox.widget.textclock(time_format, 60))
	local date = wibox.container.place(wibox.widget.textclock(date_formate, 60))
	
	local date_time = wibox.widget{
		{
			time,
			date,
			layout = wibox.layout.fixed.vertical
		},
		margins = dpi(20),
		widget = wibox.container.margin
	}
	local calendar = awful.popup{
		ontop = true,
		visible = false,
		bg = "#00000000",
		placement = function (w)
			awful.placement.bottom_right(w, {
				margins = {left = 0, top = 5, bottom = beautiful.wibar_height + dpi(5), right = dpi(5)}
			})
		end,
		widget = {
			{
				{
					date_time,
					{
						{
							require("widgets.calender"),
							margins = {top = 8, left = 16, bottom = 16, right = 16},
							widget = wibox.container.margin
						},
						bg = beautiful.bg_inner_widget,
						shape = beautiful.widget_shape,
						widget = wibox.container.background
					},
					{
						top = dpi(20),
						widget = wibox.container.margin
					},
					{
						{
							require("widgets.weather"),
							margins = dpi(16),
							widget = wibox.container.margin
						},
						bg = beautiful.bg_inner_widget,
						shape = beautiful.widget_shape,
						widget = wibox.container.background
					},

					layout = wibox.layout.fixed.vertical
				},
				top = dpi(30),
				bottom = dpi(30),
				left = dpi(25),
				right = dpi(25),
				widget = wibox.container.margin,
			},
			bg = beautiful.bg_normal,
			forced_height = popup_height,
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

