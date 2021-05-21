local awful = require("awful")
local filesystem = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")
local config_dir = filesystem.get_configuration_dir()
local default_apps = require("configurations.default-apps")
local startup_apps = {
	"picom -b --experimental-backends --config " .. config_dir .. "configurations/picom.conf",
	"redshift -t 5700:3400 -l 26.1445:91.7362",
	"udiskie",
	"xidlehook --not-when-fullscreen --not-when-audio  --timer 300 'xbacklight -set 1' 'xbacklight -set 50' --timer 60 'xbacklight -set 50;" ..default_apps.lock_screen .." ' '' --timer 900 'systemctl suspend'  ''",
	"$HOME/.local/bin/xinput-tab",
    -- Add your startup programs here
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
				image = beautiful.icon_noti_error,
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

