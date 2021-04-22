
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local brightness_slider =  function()

	-- icon
	local widget_icon = wibox.widget{
		id = "icon",
		image = beautiful.brightness_icon,
		resize = true,
		forced_height = dpi(18),
		forced_width = dpi(18),
		widget = wibox.widget.imagebox
	}
	-- slider var
	local widget_slider = wibox.widget {
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(5),
		bar_color = beautiful.fg_normal,
		bar_border_color = beautiful.border_button,
		bar_border_width = dpi(1),

		handle_shape = gears.shape.circle,
		handle_width = dpi(15),
		handle_color = beautiful.fg_normal,

		value = 40,
		minimum = 0,
		maximum = 100,
		forced_width = dpi(185),
		forced_height = dpi(20),
		widget = wibox.widget.slider
	}
	
	local widget_lebel = wibox.widget {
		text = widget_slider.value .. "%",
		font = beautiful.font,
		forced_width = dpi(35),
		widget = wibox.widget.textbox
	}

	local slider_wrapped = wibox.widget{
		{
			widget_icon,
			widget_slider,
			widget_lebel,
			spacing = dpi(5),
			fill_space = false,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.place
	}


	local set_brightness = function(value)
		awful.spawn.with_shell('xbacklight -set ' .. value)
	end


	awful.widget.watch(
		"xbacklight -get",
		5,
		function(_, stdout)
			widget_slider.value = tonumber(stdout)
			widget_lebel:set_text(math.floor(stdout) .. "%")
		end
	)


	widget_slider:connect_signal("mouse::enter", function(c)
		local wb = mouse.current_wibox
		old_cursor, old_wibox = wb.cursor, wb
		wb.cursor = "hand1"
	end)

	widget_slider:connect_signal("mouse::leave", function(c)
    	if old_wibox then
        	old_wibox.cursor = old_cursor
        	old_wibox = nil
    	end
	end)

	widget_slider:connect_signal(
		"property::value",
		function(_,value)
			set_brightness(value)
			widget_lebel:set_text(math.floor(value) .. "%")
		end
	)


	return slider_wrapped

end

return brightness_slider

