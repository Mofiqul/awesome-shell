local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require("widgets.clickable-container")
local widget_icon_dir = "/home/devops/.config/awesome/themes/codedark/icons/"

local widget = wibox.widget {
	{
		id = 'icon',
		image = beautiful.arrow_left_icon,
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
	{
		widget,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awesome.emit_signal('widget::systray:toggle')
			end
		)
	)
)

-- Listen to signal
awesome.connect_signal(
	'widget::systray:toggle',
	function()
		if screen.systray then

			if not screen.systray.visible then

				widget.icon:set_image(gears.surface.load_uncached(beautiful.arrow_left_icon))
			else

				widget.icon:set_image(gears.surface.load_uncached(beautiful.arrow_right_icon))
			end

			screen.systray.visible = not screen.systray.visible
		end
	end
)

-- Update icon on start-up
if screen.primary.systray then
	if screen.primary.systray.visible then
		widget.icon:set_image(beautiful.arrow_right_icon)
	end
end

-- Show only the tray button in the primary screen
return awful.widget.only_on_screen(widget_button, 'primary')
