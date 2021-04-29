local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- {{{ Signals
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
				top = dpi(1),
				bottom = dpi(1),
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
				widget = wibox.container.margin
			},
            --awful.titlebar.widget.ontopbutton    (c),
			{
				{
					awful.titlebar.widget.closebutton (c),
					forced_height = dpi(16),
					forced_width = dpi(16),
					widget = wibox.container.place
				},
				right = dpi(6),
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
    local is_single_client = #s.clients == 1
    --for _, c in pairs(s.clients) do
        --if (layout == 'floating' or layout == 'max') or is_single_client or c.floating or c.maximized then
            --c.border_width = 0
        --else
            --c.border_width = beautiful.border_width
        --end
    --end

    --for _, c in pairs(s.clients) do
        --if layout == 'floating' or c.floating and not c.maximized then
               --awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1")
        --else
            --awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0")
        --end
    --end
    for _, c in pairs(s.clients) do
		if (is_single_client and not c.floating)  or c.maximized then
            c.border_width = 0
    		awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0")
        elseif layout == 'floating' then
            c.border_width = 0
   			awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1")
        else
    		awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0")
            c.border_width = beautiful.border_width
        end
    end
end)


-- Toggle titlebar on or off depending on s. Creates titlebar if it doesn't exist
local function setTitlebar(client, s)
    if s then
        if client.titlebar == nil then
            client:emit_signal("request::titlebars", "rules", {})
        end
        awful.titlebar.show(client)
    else
        awful.titlebar.hide(client)
    end
end

client.connect_signal("unfocus", function (c)
	c.border_color = beautiful.border_color_normal	
end)

--Toggle titlebar on floating status change
--client.connect_signal("property::floating", function(c)
    --setTitlebar(c, c.floating)
--end)

-- Hook called when a client spawns
client.connect_signal("manage", function(c) 
    setTitlebar(c, c.first_tag.layout == awful.layout.suit.floating)
end)

-- Show titlebars on tags with the floating layout
tag.connect_signal("property::layout", function(t)
    -- New to Lua ? 
    -- pairs iterates on the table and return a key value pair
    -- I don't need the key here, so I put _ to ignore it
    for _, c in pairs(t:clients()) do
        if t.layout == awful.layout.suit.floating then
            setTitlebar(c, true)
        else
            setTitlebar(c, false)
        end
    end
end)

