local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local client = client

local taglist = function (s)

	local taglist_buttons = gears.table.join(
        awful.button({ }, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

    -- Each screen has its own tag table.
	local tag_names = {"WEB", "DEV", "TERM", "MISC", "EMG"}
	for idx, name in ipairs(tag_names) do
		local selected = false
		if idx == 1 then 
			selected = true
		end

		awful.tag.add(name, {
			screen = s,
			layout = awful.layout.suit.tile,
			selected = selected,
		})
	end

    local tags = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
	}


	local taglist_wrapped = wibox.widget {
		{
			tags,
			margins = dpi(4),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_panel_button,
		shape = beautiful.panel_button_shape,
		border_width = beautiful.button_panel_border_width,
		border_color = beautiful.border_panel_button,
		widget = wibox.container.background
    }

	return taglist_wrapped
end

return taglist
