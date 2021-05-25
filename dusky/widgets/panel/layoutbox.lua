local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local layoutbox = function (s)

	local layoutbox_wrapped = wibox.widget {
		{
			{
				{
					widget = awful.widget.layoutbox(s),
					forced_height = beautiful.wibar_icon_size,
					forced_width = beautiful.wibar_icon_size
				},
				top = dpi(4),
				bottom = dpi(4),
				left = dpi(4),
				right = dpi(4),
				widget = wibox.container.margin
			},
			shape = beautiful.panel_button_shape,
			bg = beautiful.bg_panel_button,
			border_width = beautiful.button_panel_border_width,
			border_color = beautiful.border_panel_button,
			widget = wibox.container.background
		},
		widget = wibox.container.place
	}

	layoutbox_wrapped:buttons(
		gears.table.join(
          	awful.button({ }, 1, function () awful.layout.inc( 1) end),
          	awful.button({ }, 3, function () awful.layout.inc(-1) end),
          	awful.button({ }, 4, function () awful.layout.inc( 1) end),
          	awful.button({ }, 5, function () awful.layout.inc(-1) end)
		)
	)

	return layoutbox_wrapped;
end

return layoutbox
