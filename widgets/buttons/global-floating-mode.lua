local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.buttons.create-button")

local global_floating_enabled = false

local update_global_floating_mode = function (button)
	local background = button:get_children_by_id("background")[1]
	local label = button:get_children_by_id("label")[1]

	if global_floating_enabled then
		background:set_bg(beautiful.button_active)
		label:set_text("On")
	else
		background:set_bg(beautiful.bg_button)
		label:set_text("Off")
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

local floating_mode_button = create_button.circle_big(beautiful.icon_floating)


floating_mode_button:connect_signal("button::press", function (self, _, _, button)
	if button == 1 then
		toggle_global_floating()
		update_global_floating_mode(self)
	end
end)

update_global_floating_mode(floating_mode_button)

return floating_mode_button
