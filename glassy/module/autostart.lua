local awful = require("awful")
local filesystem = require("gears.filesystem")
local naughty = require("naughty")
local beautiful = require("beautiful")
local default_apps = require("configurations.default-apps")
local config_dir = filesystem.get_configuration_dir()

local startup_apps = {
	-- Sexy blur things
	"picom -b --experimental-backends --config " .. config_dir .. "configurations/picom.conf",
	-- Night mode
	"redshift -t 5700:3400 -l 26.1445:91.7362",
	-- Automatic mount of USB devices
	"udiskie",
	-- Automatic screen lock and system suspend if user inactive
	"xidlehook --not-when-fullscreen --not-when-audio  --timer 300 'xbacklight -set 1' 'xbacklight -set 50' --timer 60 'xbacklight -set 50;" ..default_apps.lock_screen .." ' '' --timer 900 'systemctl suspend'  ''",
	-- display brightness
	"xbacklight -set 50",
	-- This is for my laptop to enable tap to click, you may or may not need it
	"$HOME/.local/bin/xinput-tab",
	-- Automatic theme switcher
	"xsettingsd"
}


local spawn_once = function (cmd)
	local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn.easy_async_with_shell(
        string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd),
        function(_, stderr)
            if not stderr or stderr == '' then
                return
            end
            naughty.notification({
                app_name = 'Startup Applications',
                title = "Error starting application",
                message = "Error while starting " .. cmd,
                timeout = 10,
                icon = beautiful.icon_noti_error,
            })
        end
    )
end

for _, app in ipairs(startup_apps) do
	spawn_once(app)
end

