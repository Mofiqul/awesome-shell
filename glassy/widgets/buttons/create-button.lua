local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local create_button = {}

function create_button.small(icon_path)

	local button_image = wibox.widget {
		id = "icon",
		image = icon_path,
		resize = true,
		forced_width = dpi(16),
		forced_height = dpi(16),
		widget = wibox.widget.imagebox
	}

	local button = wibox.widget {
		{
			button_image,
			margins = dpi(6),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		forced_width = dpi(36),
		forced_height = dpi(36),
		shape = gears.shape.circle,
		shape_border_color = beautiful.border_button,
		shape_border_width = dpi(1),
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
-- @path icon_path icon path
-- @param initial_action Callback function at startup
-- @param onclick_action Callback function at onclick
function create_button.circle_big(icon_path, initial_action, onclick_action)

	local button_image = wibox.widget {
		image = icon_path,
		resize = true,
		forced_width = dpi(22),
		forced_height = dpi(22),
		widget = wibox.widget.imagebox
	}

	local button = wibox.widget {
		{
			button_image,
			margins = dpi(15),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		shape = gears.shape.circle,
		shape_border_color = beautiful.border_button,
		shape_border_width = dpi(1),
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


	button:buttons(
		gears.table.join(
    		button:buttons(),
			-- Click action
    		awful.button({}, 1, nil, function ()
        		if onclick_action then
					onclick_action()
					if initial_action then
						initial_action(button)
					end
				end
    		end)
		)
	)
	-- Sets the button status at startup
	if initial_action then
		initial_action(button)
	end

	return button
end



return create_button
