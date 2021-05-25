local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local default_apps = require("configurations.default-apps")
local clickable_container = require("widgets.clickable-container")

local widget_menu = wibox.widget{
	{
		{
			{
				image = beautiful.awesome_menu_icon,
				resize = true,
				forced_height = beautiful.wibar_icon_size,
				forced_width = beautiful.wibar_icon_size,
				widget = wibox.widget.imagebox
			},
			margins = dpi(4),
			widget = wibox.container.margin
		},
		id = "background",
		bg = beautiful.bg_panel_button,
		shape = beautiful.panel_button_shape,
		border_width = beautiful.button_panel_border_width,
		border_color = beautiful.border_panel_button,
		widget = wibox.container.background
	},
	widget = clickable_container
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
