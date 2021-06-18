local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local dpi = beautiful.xresources.apply_dpi
local awesome = awesome
local client = client

-- Toggle titlebar on or off depending on s. Creates titlebar if it doesn't exist
local function setTitlebar(client, s)
    if s then
        awful.titlebar.show(client)
    else
        awful.titlebar.hide(client)
    end
end

local set_client_icon = function (c)
	local icon = menubar.utils.lookup_icon(c.instance)
    local lower_icon = menubar.utils.lookup_icon(c.instance:lower())
    --Check if the icon exists
    if icon ~= nil then
		local new_icon = gears.surface(icon)
        c.icon = new_icon._native

    --Check if the icon exists in the lowercase variety
    elseif lower_icon ~= nil then
        local new_icon = gears.surface(lower_icon)
        c.icon = new_icon._native

    --Check if the client already has an icon. If not, give it a default.
    elseif c.icon == nil then
        local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
		c.icon = new_icon._native
	end
end


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
	
	if awful.layout.suit.floating or c.floating then
		awful.placement.centered(c)
	end


	set_client_icon(c)
	setTitlebar(c, c.first_tag.layout == awful.layout.suit.floating)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
			{
				awful.titlebar.widget.iconwidget(c),
				left = dpi(6),
				top = dpi(4),
				bottom = dpi(4),
				widget = wibox.container.margin
			},
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
			{
				{
					awful.titlebar.widget.minimizebutton(c),
					forced_height = dpi(16),
					forced_width = dpi(16),
					widget = wibox.container.place
				},
				right = dpi(6),
				top = dpi(4),
				bottom = dpi(4),
				widget = wibox.container.margin
			},
			{
				{
					awful.titlebar.widget.maximizedbutton(c),
					forced_height = dpi(16),
					forced_width = dpi(16),
					widget = wibox.container.place
				},
				right = dpi(6),
				top = dpi(4),
				bottom = dpi(4),

				widget = wibox.container.margin
			},
			{
				{
					awful.titlebar.widget.closebutton (c),
					forced_height = dpi(16),
					forced_width = dpi(16),
					widget = wibox.container.place
				},
				right = dpi(6),
				top = dpi(4),
				bottom = dpi(4),
				widget = wibox.container.margin
			},
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
    --c:emit_signal("request::activate", "mouse_enter", {raise = false})
--end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

screen.connect_signal("arrange", function (s)
    local layout = s.selected_tag.layout.name
    for _, c in pairs(s.clients) do
		if c.maximized then
            c.border_width = 0
    		awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
        elseif layout == 'floating' then
            c.border_width = 0
   			awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1", false)
        else
    		awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
            c.border_width = beautiful.border_width
        end
    end
end)

-- Show titlebars on tags with the floating layout
tag.connect_signal("property::layout", function(t)
    for _, c in pairs(t:clients()) do
        if t.layout == awful.layout.suit.floating then
            setTitlebar(c, true)
        else
            setTitlebar(c, false)
        end
    end
end)

--Toggle titlebar on floating status change
--client.connect_signal("property::floating", function(c)
    --setTitlebar(c, c.floating)
--end)
