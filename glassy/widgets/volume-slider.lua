local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local volume_slider =  function()

	-- icon
	local widget_icon = wibox.widget{
		id = "icon",
		image = beautiful.volume_normal_icon,
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
		--max_value     = 100,
		--value         = 50,
		--forced_height = dpi(10),
		--forced_width  = dpi(170),
		--margins = {top = dpi(8), bottom = dpi(8)},
		--border_width  = 0,
		--color = beautiful.fg_normal,
		--background_color = beautiful.bg_button,
		--shape = gears.shape.rounded_bar,
		--bar_shape = gears.shape.rounded_bar,
		--widget = wibox.widget.progressbar,
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
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.place
	}


	local update_volume_icon = function()
		awful.spawn.easy_async(
			[[ sh -c "pacmd list-sinks | awk '/muted/ { print \$2 }'"]],
			function(stdout)
				if stdout:match("yes") then
					widget_icon:set_image(beautiful.volume_muted_icon)
				elseif stdout:match("no") then
					widget_icon:set_image(beautiful.volume_normal_icon)
				end
			end
		)
	end

	local toggle_mute = function()
		awful.spawn.easy_async(
			'amixer -D pulse set Master 1+ toggle',
			function(_)
				update_volume_icon()
			end
		)
	end

	local set_volume = function(vol)
		awful.spawn.with_shell('amixer -D pulse sset Master ' .. vol .. '%')
	end


	awful.widget.watch(
		[[bash -c "amixer -D pulse sget Master"]],
		5,
		function(_, stdout)
			local volume = string.match(stdout, '(%d?%d?%d)%%')
			widget_slider.value = tonumber(volume)
			widget_lebel:set_text(volume.. "%")
		end
	)


	local old_cursor, old_wibox
	widget_icon:connect_signal("mouse::enter", function(c)
		local wb = mouse.current_wibox
		old_cursor, old_wibox = wb.cursor, wb
		wb.cursor = "hand1"
	end)

	widget_icon:connect_signal("mouse::leave", function(c)
    	if old_wibox then
        	old_wibox.cursor = old_cursor
        	old_wibox = nil
    	end
	end)
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
			--local v = math.floor((value-0)/(170-0) * (100-0) + 0)
			set_volume(value)
			widget_lebel:set_text(value .. "%")
		end
	)

	widget_icon:connect_signal(
		"button::press",
		function(_,_,_, button)
			if (button == 1) then
				toggle_mute()
			end
		end
	)

	update_volume_icon()

	return slider_wrapped

end

return volume_slider

