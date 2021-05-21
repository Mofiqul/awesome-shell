local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local volume_slider =  function()

	-- icon
	local icon  = wibox.widget{
		id = "icon",
		image = beautiful.volume_normal_icon,
		resize = true,
		forced_height = dpi(16),
		forced_width = dpi(16),
		widget = wibox.widget.imagebox
	}
	local button = wibox.widget{
		{
			icon,
			margins = dpi(4),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_button,
		shape = gears.shape.circle,
		widget = wibox.container.background
	}
	-- slider var
	local widget_slider = wibox.widget {
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(3),
		bar_color = beautiful.bg_focus .. "55",
		bar_active_color = beautiful.bg_focus,

		handle_shape = gears.shape.circle,
		handle_width = dpi(12),
		handle_color = beautiful.bg_focus,

		value = 40,
		minimum = 0,
		maximum = 100,
		forced_height = dpi(20),
		widget = wibox.widget.slider
	}

	local slider_wrapped = wibox.widget{
			button,
			widget_slider,
			spacing = dpi(10),
			forced_width = dpi(280),
			layout = wibox.layout.fixed.horizontal
	}


	local update_volume_icon = function()
		awful.spawn.easy_async(
			[[ sh -c "pacmd list-sinks | awk '/muted/ { print \$2 }'"]],
			function(stdout)
				if stdout:match("yes") then
					icon:set_image(beautiful.volume_muted_icon)
					button:set_bg(beautiful.bg_button)
				elseif stdout:match("no") then
					icon:set_image(beautiful.volume_normal_icon)
					button:set_bg(beautiful.button_active)
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
		end
	)


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
		end
	)

	button:connect_signal(
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

