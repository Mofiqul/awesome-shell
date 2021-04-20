local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local global_floating_enabled = false

local update_global_floating_mode = function (button)
	if global_floating_enabled then
		button:set_bg(beautiful.button_active)
	else
		button:set_bg(beautiful.bg_button)
	end
end

local toggle_global_floating = function ()
	local tags = awful.screen.focused().tags
	if not global_floating_enabled then
		for _,tag in ipairs(tags) do
			awful.layout.set(awful.layout.suit.floating, tag)
		end
		global_floating_enabled = true
	else 
		for _,tag in ipairs(tags) do
			awful.layout.set(awful.layout.suit.tile, tag)
		end
		global_floating_enabled = false
	end
end

local floating_mode_button = create_button.circle_big(
	beautiful.icon_floating,
	update_global_floating_mode,
	toggle_global_floating
)

return floating_mode_button
