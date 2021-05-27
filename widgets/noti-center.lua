local awful = require('awful')
local wibox = require('wibox')
local naughty = require("naughty")
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require("widgets.clickable-container")

local bg_button = ""
if beautiful.mode == "dark" then
	bg_button = beautiful.bg_normal
elseif beautiful.mode == "glassy" then
	bg_button = beautiful.bg_button_alt
end

local clear_all_button = wibox.widget{
	{
		{
			--{
				--image = beautiful.icon_clear_all,
				--resize = true,
				--forced_height = dpi(20),
				--forced_width = dpi(20),
				--widget = wibox.widget.imagebox
			--},
			{
				text = "Clear all",
				font = beautiful.font_extra_small,
				widget = wibox.widget.textbox
			},
			margins = dpi(2),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},

--	bg = beautiful.bg_button,
--	border_width = beautiful.btn_border_width,
--	border_color = beautiful.border_button,
	widget = wibox.container.background
}

clear_all_button:connect_signal("button::press", function (_, _, _, button)
	if button == 1 then
		_G.reset_notifbox_layout()
	end
end)


local time_to_seconds = function(time)
	local hourInSec = tonumber(string.sub(time, 1, 2)) * 3600
	local minInSec = tonumber(string.sub(time, 4, 5)) * 60
	local getSec = tonumber(string.sub(time, 7, 8))
	return (hourInSec + minInSec + getSec)
end


local empty_notifbox = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5),
        {
            expand = 'none',
            layout = wibox.layout.align.horizontal,
            nil,
            {
                image = beautiful.icon_empty_notibox,
                resize = true,
                forced_height = dpi(64),
                forced_width = dpi(64),
				opacity = .1,
                widget = wibox.widget.imagebox
            },
            nil
        },
        {
            markup = 'You have no new notification',
            font = beautiful.font,
            align = 'center',
            valign = 'center',
			opacity = .1,
            widget = wibox.widget.textbox
        }
    },
    margins = dpi(20),
    widget = wibox.container.margin

}


local scroller = function(widget)
    widget:buttons(gears.table.join(awful.button({}, 4, nil, function()
        if #widget.children == 1 then return end
        widget:insert(1, widget.children[#widget.children])
        widget:remove(#widget.children)
    end), awful.button({}, 5, nil, function()
        if #widget.children == 1 then return end
        widget:insert(#widget.children + 1, widget.children[1])
        widget:remove(1)
    end)))
end


local create_notifbox =  function (n)
    local pop_time = os.date("%H:%M:%S")
	local exact_time = os.date('%I:%M %p')
	local exact_date_time = os.date('%b %d, %I:%M %p')

	local icon = wibox.widget{
		image = n.icon,
		resize = true,
		valign = "center",
		halign = "center",
		forced_height = dpi(42),
		forced_width = dpi(42),
		--clip_shape = gears.shape.circle,
		vertical_fit_policy = "filt",
		horizontal_fit_policy = "filt",
		max_scaling_factor = 2,
		widget = wibox.widget.imagebox
	}

	local app_icon = function ()
		local widget = nil
		if n.app_icon ~= nil then
			widget = wibox.widget{
				image = n.app_icon,
				resize = true,
				forced_height = dpi(16),
				clip_shape = gears.shape.circle,
				forced_width = dpi(16),
				widget = wibox.widget.imagebox
			}
		end
		return widget
	end


	local dismiss_button = wibox.widget{
		{
			{
				{
					image = beautiful.icon_times,
					resize = true,
					forced_height = dpi(14),
					forced_width = dpi(14),
					widget = wibox.widget.imagebox
				},
				margins = dpi(1),
				widget = wibox.container.margin
			},
			bg = bg_button,
			border_width = beautiful.btn_border_width,
			border_color = bg_button,
			shape = gears.shape.circle,
			widget = wibox.container.background
		},
		widget = clickable_container
	}


	local app_name = wibox.widget{
		markup = n.app_name or "System Notification",
		font = beautiful.font_bold,
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local notification_time = wibox.widget{
		text = "",
		font = beautiful.font_extra_small,
		widget = wibox.widget.textbox
	}

	-- Update notification time
	gears.timer {
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = function()

			local time_difference = nil

			time_difference = time_to_seconds(os.date('%H:%M:%S')) - time_to_seconds(pop_time)
			time_difference = tonumber(time_difference)

			if time_difference < 60 then
				notification_time:set_text('now')

			elseif time_difference >= 60 and time_difference < 3600 then
				local time_in_minutes = math.floor(time_difference / 60)
				notification_time:set_text(time_in_minutes .. 'm ago')

			elseif time_difference >= 3600 and time_difference < 86400 then
				notification_time:set_text(exact_time)

			elseif time_difference >= 86400 then
				notification_time:set_text(exact_date_time)
				return false

			end

			collectgarbage('collect')
		end
	}

	local app_icon_with_name_and_dismiss_btn = wibox.widget{
		{
			app_icon(),
			app_name,
			spacing = beautiful.notification_margin,
			layout = wibox.layout.fixed.horizontal
		},
		nil,
		notification_time,
		expand = "inside",
		spacing = beautiful.notification_margin,
		layout = wibox.layout.align.horizontal
	}



	local action_list = wibox.widget {
		notification = n,
		base_layout = wibox.widget {
			spacing = beautiful.notification_margin,
			layout = wibox.layout.fixed.horizontal
		},
		widget_template = {
			{
				{
					{
						id = 'text_role',
						align = "center",
						valign = "center",
						widget = wibox.widget.textbox
					},
					top = dpi(4),
					bottom = dpi(4),
					left = dpi(10),
					right = dpi(10),
					widget = wibox.container.margin
				},
				bg = bg_button,
				shape = gears.shape.rounded_bar,
				widget = wibox.container.background,
			},
			widget  = clickable_container,
		},
		style = { underline_normal = false, underline_selected = true },
		widget = naughty.list.actions,
	}

	local title_area_and_message = wibox.widget{
		{
			markup = "<b>" .. n.title .. "</b>",
			font = beautiful.font_small,
			widget = wibox.widget.textbox,
		},
		{
			markup = n.message,
			font = beautiful.font_small,
			widget = wibox.widget.textbox
		},
		spacing = beautiful.notification_margin,
		forced_width = dpi(177),
		layout = wibox.layout.fixed.vertical
	}


	local notibox = wibox.widget{
			app_icon_with_name_and_dismiss_btn,
			{
				icon,
				title_area_and_message,
				spacing = beautiful.notification_margin,
				layout = wibox.layout.fixed.horizontal
			},
			spacing = beautiful.notification_margin,
			layout = wibox.layout.fixed.vertical
	}


	local box = wibox.widget{
		{
			{
				notibox,
				action_list,
				spacing = beautiful.notification_margin,
				widget = wibox.layout.fixed.vertical
			},
			margins = beautiful.notification_margin,
			widget = wibox.container.margin
		},
		bg = beautiful.bg_inner_widget,
		shape = beautiful.widget_shape,
		widget = wibox.container.background
	}

	box:connect_signal("mouse::enter", function ()
		app_icon_with_name_and_dismiss_btn.third = dismiss_button
	end)

	box:connect_signal("mouse::leave", function ()
		app_icon_with_name_and_dismiss_btn.third = notification_time
	end)


	dismiss_button:connect_signal("button::press", function (_, _, _, button)
		if button == 1 then
            _G.remove_notifbox(box)
		end
	end)

	collectgarbage('collect')

	return box
end



local notifbox_layout = wibox.layout.fixed.vertical()
scroller(notifbox_layout)
notifbox_layout.spacing = dpi(10)
--notifbox_layout.forced_width = dpi(300)

reset_notifbox_layout = function()
    notifbox_layout:reset(notifbox_layout)
    notifbox_layout:insert(1, empty_notifbox)
    remove_notifbox_empty = true
end

remove_notifbox = function(box)
    notifbox_layout:remove_widgets(box)

    if #notifbox_layout.children == 0 then
        notifbox_layout:insert(1, empty_notifbox)
        remove_notifbox_empty = true
    end
end

notifbox_layout:insert(1, empty_notifbox)

naughty.connect_signal("added", function(n)

	if #notifbox_layout.children == 1 and remove_notifbox_empty then
		notifbox_layout:reset(notifbox_layout)
		remove_notifbox_empty = false
	end

	local notifbox_color = beautiful.bg_normal
	if n.urgency == 'critical' then
		notifbox_color = beautiful.bg_urgent
	end

	notifbox_layout:insert(1,create_notifbox(n))
end)

return notifbox_layout
