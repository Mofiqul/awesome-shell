local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


local systray = wibox.widget.systray
systray.base_size = dpi(16)

local widget_systray = wibox.widget{
	{
		{
			systray,
			margins = dpi(4),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_panel_button,
		shape = beautiful.panel_button_shape,
		border_width = beautiful.button_panel_border_width,
		border_color = beautiful.border_panel_button,
		widget = wibox.container.background
	},
	margins = dpi(2),
	widget = wibox.container.margin
}
return widget_systray
