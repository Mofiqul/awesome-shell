local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widgets.clickable-container")
local create_button = {}

function create_button.small(icon_path)

	local button_image = wibox.widget {
		id = "icon",
		image = icon_path,
		resize = true,
		forced_width = dpi(22),
		forced_height = dpi(22),
		widget = wibox.widget.imagebox
	}

	local button = wibox.widget {
		{
			button_image,
			margins = dpi(8),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		shape = gears.shape.circle,
        widget = wibox.container.background
	}


	local old_cursor, old_wibox

	button:connect_signal("mouse::enter", function(c)
    	local wb = mouse.current_wibox
    	old_cursor, old_wibox = wb.cursor, wb
    	wb.cursor = "hand1"
	end)
	button:connect_signal("mouse::leave", function(c)
    	if old_wibox then
        	old_wibox.cursor = old_cursor
        	old_wibox = nil
    	end
	end)

	return button
end

--- Creates big size circle button
--- @param icon_path string
function create_button.circle_big(icon_path)

	local button_with_label = wibox.widget{
		{
			{
				{
					{
						{
							id = "icon",
							image = icon_path,
							resize = true,
							forced_width = dpi(18),
							forced_height = dpi(18),
							widget = wibox.widget.imagebox
						},
						widget = wibox.container.place
					},
					margins = dpi(10),
					widget = wibox.container.margin
				},
				id = "background",
				bg = beautiful.bg_button,
				shape = gears.shape.circle,
				widget = wibox.container.background
			},
			{
				{
					id = "label",
					text = "Off",
					font = "Ubuntu 8",
					widget = wibox.widget.textbox
				},
				forced_width = dpi(50),
				widget = wibox.container.place
			},
			spacing = dpi(6),
			layout = wibox.layout.fixed.vertical
		},
		widget = clickable_container
	}

	return button_with_label
end


function create_button.button_with_label(name, icon)
	local button_label= wibox.widget {
		text = name,
		font = 'Ubuntu 10',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local button = wibox.widget {
		{
			{
				{
					{
						image = icon,
						resize = true,
						forced_height = dpi(24),
						forced_width = dpi(24),
						widget = wibox.widget.imagebox
					},
					widget = wibox.container.place
				},
				button_label,
				spacing = beautiful.widget_margin,
				widget = wibox.layout.fixed.vertical,
			},
			margins = dpi(16),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		shape = beautiful.widget_shape,
		widget = wibox.container.background,
		forced_width = dpi(95)
	}
	
	
	local old_cursor, old_wibox

	button:connect_signal("mouse::enter", function(c)
    	local wb = mouse.current_wibox
    	old_cursor, old_wibox = wb.cursor, wb
    	wb.cursor = "hand1"
	end)
	button:connect_signal("mouse::leave", function(c)
    	if old_wibox then
        	old_wibox.cursor = old_cursor
        	old_wibox = nil
    	end
	end)

	return button
end


return create_button
