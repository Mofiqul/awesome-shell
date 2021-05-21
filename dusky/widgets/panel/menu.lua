local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local default_apps = require("configurations.default-apps")
local clickable_container = require("widgets.clickable-container")

local widget_menu = wibox.widget{
	{	{
			{
				{
					image = beautiful.awesome_menu_icon,
					resize = true,
					widget = wibox.widget.imagebox
				},
				left = dpi(6),
				right = dpi(2),
				top = dpi(2),
				bottom = dpi(2),
				widget = wibox.container.margin
			},
			id = "background",
			bg = beautiful.bg_panel_button,
			shape = beautiful.panel_button_shape,
			border_width = beautiful.button_panel_border_width,
			border_color = beautiful.border_panel_button,
			widget = wibox.container.background
		},
		margins = dpi(2),
		widget = wibox.container.margin
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
