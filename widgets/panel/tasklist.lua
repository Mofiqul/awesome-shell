local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local client = client

local tasklist = function (s)

	local tasklist_buttons = gears.table.join(
		awful.button({ }, 1, function (c)
		   	if c == client.focus then
			   	c.minimized = true
		   	else
			   	c:emit_signal(
				   	"request::activate",
				   	"tasklist",
				   	{raise = true}
			   	)
		   	end
		end),
		awful.button({ }, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
		end),
		awful.button({ }, 4, function ()
			awful.client.focus.byidx(1)
		end),
		awful.button({ }, 5, function ()
			awful.client.focus.byidx(-1)
		end)
	)

	local widget_tasklist = awful.widget.tasklist {
		screen   = s,
		filter   = awful.widget.tasklist.filter.currenttags,
		buttons  = tasklist_buttons,
		layout   = {
			layout  = wibox.layout.fixed.horizontal,
			spacing = dpi(4)
		},
		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			{
				{
					{
						widget = wibox.container.background,
						id = "background_role",
						forced_height = dpi(2)
					},
					{
						{
							awful.widget.clienticon,
							left = dpi(4),
							widget = wibox.container.margin
						},
						{
							{
								{
									id     = 'text_role',
									widget = wibox.widget.textbox
								},
								right = dpi(4),
								top = dpi(-2),
								widget = wibox.container.margin
							},
							widget = wibox.container.place
						},
						spacing = dpi(4),
						layout = wibox.layout.fixed.horizontal
					},
					widget = wibox.layout.align.vertical,
				},
				widget = wibox.container.background,
				id = "background"
			},
			widget = wibox.container.place,
			create_callback = function (self, c, index, objects)
				self:get_children_by_id('background')[1].bg = beautiful.bg_tasklist_active
			end,
			update_callback = function (self, c, index, objects)
				local widget_background = self:get_children_by_id("background")[1]
				if c.active then
					widget_background.bg = beautiful.bg_tasklist_active
				elseif c.minimized then
					widget_background.bg = beautiful.bg_minimize
				else
					widget_background.bg = beautiful.bg_tasklist_inactive
				end
			end
		},
	}

	return widget_tasklist

end

return tasklist
