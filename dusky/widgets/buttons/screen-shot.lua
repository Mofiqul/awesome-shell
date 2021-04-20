local awful = require("awful")
local beautiful = require("beautiful")
local filesystem = require("gears").filesystem
local naughty = require("naughty")
local create_button = require("widgets.buttons.create-button")

function sleep(n)
  local t = os.clock()
  while os.clock() - t <= n do
    -- nothing
  end
end

local take_screen_shot = function ()
	awesome.emit_signal("control-center::hide")
	sleep(.2)

	local screen_shot_dir = "~/Pictures/Screenshots/"
	
	if not filesystem.dir_readable(screen_shot_dir) then
		awful.spawn.with_shell("mkdir -p " .. screen_shot_dir)
	end
	
	local file_name = os.date("%d-%m-%Y-%H:%M:%S") .. ".png"
	local command = "scrot '" .. file_name .. "' -e 'mv $f " .. screen_shot_dir .."'"
	awful.spawn.with_shell(command)

	local open_file = naughty.action{
		name = "Open",
		icon_only = false
	}

	local open_dir = naughty.action{
		name = "Open Folder",
		icon_only = false
	}

	local delete_file = naughty.action{
		name = "Delete",
		icon_only = false
	}

	open_file:connect_signal('invoked', function()
		awful.spawn.with_shell('xdg-open ' .. screen_shot_dir .. file_name, false)
	end)

	open_dir:connect_signal('invoked', function()
		awful.spawn.with_shell('xdg-open ' .. screen_shot_dir, false)
	end)

	delete_file:connect_signal('invoked', function()
		awful.spawn.with_shell('gio trash ' .. screen_shot_dir .. file_name, false)
	end)

	naughty.notification({
		app_name = 'Screenshot Tool',
		icon = beautiful.icon_noti_screenhost,
		timeout = 10,
		title = '<b>Screenshot taken</b>',
		message = 'Screenshot saved to ' .. screen_shot_dir .. file_name,
		actions = { open_file, open_dir, delete_file }
	})
end

local screen_shot_button = create_button.circle_big(beautiful.icon_camera, nil, take_screen_shot)

return screen_shot_button
