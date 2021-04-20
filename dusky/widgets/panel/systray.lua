local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")


local systray = wibox.widget{
	{
		widget = wibox.widget.systray
	},
	visible = false,
	left = dpi(6),
	widget = wibox.container.margin
}

local toggle_button_icon = wibox.widget {
	id = 'icon',
	image = beautiful.arrow_left_icon,
	widget = wibox.widget.imagebox,
	resize = true
}

local widget_systray = wibox.widget{
	{
		{
			{
				systray,
				toggle_button_icon,
				layout = wibox.layout.fixed.horizontal
			},
			left = dpi(2),
			right = dpi(2),
			top = dpi(2),
			bottom = dpi(2),
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

toggle_button_icon:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				systray.visible = not systray.visible

				if systray.visible then
					toggle_button_icon:set_image(beautiful.arrow_right_icon)
				else
					toggle_button_icon:set_image(beautiful.arrow_left_icon)
				end
			end
		)
	)
)
return widget_systray
