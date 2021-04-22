
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local battery_widget = {}

local function worker(user_args)
    local args = user_args or {}

    local font = beautiful.font
    local path_to_icons = gfs.get_configuration_dir() .. "themes/default/icons/battery/"

    local timeout = args.timeout or 10


    if not gfs.dir_readable(path_to_icons) then
        naughty.notify{
            title = "Battery Widget",
            text = "Folder with icons doesn't exist: " .. path_to_icons,
            preset = naughty.config.presets.critical
        }
    end

    local icon_widget = wibox.widget {
        widget = wibox.widget.imagebox,
        resize = true,
    }

    local level_widget = wibox.widget {
        font = font,
        widget = wibox.widget.textbox
    }

    battery_widget = wibox.widget {
		{
			icon_widget,
        	--level_widget,
			spacing = dpi(2),
        	layout = wibox.layout.fixed.horizontal,
    	},
		layout = wibox.container.place
	}

    local function show_battery_notification(msg, title, icon, timeout)
        naughty.notification ({
			app_name = "Power Manager",
            icon = icon,
            text = msg,
            title = title,
            timeout = timeout or 20, -- show the warning for a longer time
        })
    end

    local last_battery_check = os.time()
    local batteryType = "battery-good"

    watch("acpi -i", timeout,
    function(widget, stdout)
        local battery_info = {}
        local capacities = {}
        for s in stdout:gmatch("[^\r\n]+") do
            local status, charge_str, _ = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?(.*)')
            if status ~= nil then
                table.insert(battery_info, {status = status, charge = tonumber(charge_str)})
            else
                local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
                table.insert(capacities, tonumber(cap_str))
            end
        end

        local capacity = 0
        for _, cap in ipairs(capacities) do
            capacity = capacity + cap
        end

        local charge = 0
        local status
        for i, batt in ipairs(battery_info) do
            if batt.charge >= charge then
                status = batt.status -- use most charged battery status
                -- this is arbitrary, and maybe another metric should be used
            end

            charge = charge + batt.charge * capacities[i]
        end
        charge = charge / capacity

        level_widget.text = string.format('%d%%', charge)

        if (charge >= 0 and charge < 15) then
            if status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
                -- if 5 minutes have elapsed since the last warning
                last_battery_check = os.time()
				local msg = "Battery is criticaly low, save your work or plug adapter"
				local title = "<b>Battery criticaly low</b>"
                show_battery_notification(msg, title, beautiful.icon_bat_caution, 20)
            end
        end

        if status == 'Charging' then
            batteryType = "battery-charging"
        else
            batteryType = "battery-normal"
        end

        widget:set_image(path_to_icons .. batteryType .. ".svg")

    end,
    icon_widget)

    return wibox.container.margin(battery_widget)
end

return setmetatable(battery_widget, { __call = function(_, ...) return worker(...) end })
