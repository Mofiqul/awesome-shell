local awful = require("awful")

local redshift = {}
redshift.redshift = "/usr/bin/redshift"    -- binary path
redshift.method = "randr"                  -- randr or vidmode
redshift.state = 1                         -- 1 for screen dimming, 0 for none

redshift.dim = function()
    awful.util.spawn("pkill -USR1 redshift")
    redshift.state = 1
end

redshift.undim = function()
    awful.util.spawn("pkill -USR1 redshift")
    redshift.state = 0
end
redshift.toggle = function()
    if redshift.state == 1
    then
        redshift.undim()
    else
        redshift.dim()
    end
end
redshift.init = function(initState)
    if initState == 1
    then
        redshift.dim()
    else
        redshift.undim()
    end
end

return redshift
