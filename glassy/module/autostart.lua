local awful = require("awful")
local filesystem = require("gears.filesystem")
local naughty = require("naughty")
local config_dir = filesystem.get_configuration_dir()

local startup_apps = {
	"picom -b --experimental-backends --config " .. config_dir .. "configurations/picom.conf",
	"redshift -t 5700:3400 -l 26.1445:91.7362",
	-- USB auto mount
	"udiskie",
	-- Polkit agent
--	"/usr/lib/xfce-polkit/xfce-polkit",
	-- Keyring
--	"eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)",
	-- display brightness
	"xbacklight -set 40",
	--"xsetroot -cursor_name left_ptr"
	"$HOME/.local/bin/xinput-tab"
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
                icon = config_dir .. "themes/codedark/icons/error.svg",
            })
        end
    )
end

for _, app in ipairs(startup_apps) do
	spawn_once(app)
end

