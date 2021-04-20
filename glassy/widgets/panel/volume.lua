local wibox = require("wibox")
local beautiful = require("beautiful")

local volume = {
    delta = 5
}

function volume:toggle()
    volume:_cmd('amixer sset Master toggle')
end

function volume:raise()
    volume:_cmd('amixer sset Master ' .. tostring(volume.delta) .. '%+')
end
function volume:lower()
    volume:_cmd('amixer sset Master ' .. tostring(volume.delta) .. '%-')
end

local function worker()
    volume.delta = 5

    volume.widget = wibox.widget {
        {
            id = "icon",
            image = beautiful.volume_normal_icon,
            resize = true,
            widget = wibox.widget.imagebox,
        },
        layout = wibox.container.margin,
        set_image = function(self, path)
            self.icon.image = path
        end
    }

    return volume.widget
end

return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
