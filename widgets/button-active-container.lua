-- A background widget for buttons
-- Can active and inactive background color on click or whatever

local wibox = require("wibox")
local beautiful = require("beautiful")

local widget_bg = function(widget)
	local container = wibox.widget {
		widget,
		widget = wibox.container.background,
		bg = beautiful.bg_panel_button,
		shape = beautiful.panel_button_shape,
		border_width = beautiful.button_panel_border_width,
		border_color = beautiful.border_panel_button,
	}
	container.set_inactive = function ()
		container.bg = beautiful.bg_panel_button
		container.shape = beautiful.panel_button_shape
		container.border_width = beautiful.button_panel_border_width
		container.border_color = beautiful.border_panel_button
	end

	container.set_active = function ()
		container.bg = beautiful.bg_panel_button_active
		container.shape = beautiful.panel_button_shape_active
		container.border_width = beautiful.button_panel_border_width_active
		container.border_color = beautiful.border_panel_button_active
	end

	return container
end


return widget_bg
