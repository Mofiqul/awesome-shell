local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local default_apps = require("configurations.default-apps")


local widget_menu = wibox.widget{
	{
		{
			{
				image = beautiful.awesome_menu_icon,
				resize = true,
				widget = wibox.widget.imagebox
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

widget_menu:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn(default_apps.app_menu, false)	
			end
		)
	)
)
return widget_menu
