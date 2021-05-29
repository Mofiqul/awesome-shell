local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir () .. "themes/default/"
local theme = {}

-- Theme name, available values "dark" and "glassy"
theme.mode = "dark"
-- Fonts
theme.font = "Ubuntu 10"
theme.font_bold = "Ubuntu 10"
theme.font_large = "Ubuntu 12"
theme.font_large_bold = "Ubuntu bold 12"
theme.font_small =  "Ubuntu 9"
theme.font_extra_small =  "Ubuntu 9"
theme.taglist_font = "Ubuntu Nerd Font 12"

-- Colors Definations
local colors = {}

colors.transparent = "#00000000"
colors.red = "#F44747"
colors.blue = "#1B6ACB"
colors.green = "#2EA043"
colors.yellow = "#F36351"

if theme.mode == "dark" then
    colors.bg = "#282828DD"
    colors.bg_alt = "#767676"
    colors.fg = "#ffffff"
    colors.gray = "#4B4B4B"
    colors.dark_gray = "#3B3B3B"
    colors.light_gray = "#515151"
elseif theme.mode == "glassy" then
    colors.bg = "#11111199"
    colors.bg_alt = "#767676AA"
    colors.fg = "#ffffff"
    colors.gray = "#282828AA"
    colors.dark_gray = "#000000AA"
    colors.light_gray = "#515151AA"
end

-- Main colors
theme.bg_transparent = colors.transparent
theme.bg_normal     = colors.bg
theme.bg_normal_alt = colors.bg_alt
theme.bg_focus      = colors.blue
theme.bg_urgent     = colors.red
theme.bg_minimize   = colors.transparent
theme.bg_inner_widget = colors.dark_gray

theme.fg_normal     = colors.fg
theme.fg_focus      = colors.fg
theme.fg_urgent     = colors.fg
theme.fg_minimize   = colors.fg

-- button colors
theme.bg_button = colors.dark_gray
theme.bg_button_alt = colors.gray
theme.bg_panel_button = colors.transparent
theme.bg_panel_button_active = colors.dark_gray
theme.border_button = colors.dark_gray -- "#51514f"
theme.border_panel_button = colors.transparent
theme.border_panel_button_active = colors.dark_gray
theme.button_active = colors.blue
theme.button_active_alt = colors.green


--- Border colors
theme.border_normal = colors.light_gray
theme.border_focus  = colors.blue
theme.border_marked = colors.red
theme.bg_yellow = colors.yellow

-- Tasklist colors
theme.bg_tasklist_active = colors.blue .. "33"
theme.bg_tasklist_inactive = colors.transparent

-- Margins, gaps, paddings and border width
theme.notification_margin = dpi(6)
theme.widget_margin = dpi(6)
theme.btn_xs_margin = dpi(3)
theme.btn_md_margin = dpi(5)
theme.btn_border_width = dpi(1)
theme.widget_border_width = dpi(1)
theme.widget_margin = dpi(6)
theme.useless_gap   = dpi(1)
theme.gap_single_client = true
theme.maximized_hide_border = true
theme.border_width  = dpi(1)
theme.button_panel_border_width = dpi(0)
theme.button_panel_border_width_active = dpi(1)

-- shapes
theme.btn_xs_shape = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 4)
end

-- theme.btn_lg_shape = function (cr, height, width)
--     gears.shape.rounded_rect(cr, height, width, 6)
-- end
theme.btn_lg_shape = gears.shape.circle

theme.btn_rounded = gears.shape.rounded_bar

theme.widget_shape = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 10)
end

theme.widget_shape_alt = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 6)
end

theme.panel_button_shape = nil
theme.panel_button_shape_active = gears.shape.rounded_bar

--- Icons
theme.icon_times = theme_path .. "icons/remove.svg"
-- awesome icon
theme.awesome_menu_icon = theme_path .. "icons/awesome.svg"
--- Update toggle icons
theme.icon_update_none = theme_path .. "icons/update-none.svg"
theme.icon_update_available = theme_path .."icons/update-low.svg"
--- Previous and Next icon
theme.icon_previous = theme_path .. "icons/go-previous.svg"
theme.icon_next = theme_path .. "icons/go-next.svg"

theme.icon_focus_mode = theme_path .. "icons/focus-mode.svg"

theme.brightness_icon = theme_path .. "icons/brightness.svg"

theme.battery_icon = theme_path .. "icons/battery/battery-normal.svg"
theme.battery_icon_charging = theme_path .. "icons/battery/battery-charging.svg"
theme.icon_ac = theme_path .. "icons/battery/ac.svg"
theme.volume_normal_icon = theme_path .. "icons/volume/audio-volume-high.svg"
theme.volume_muted_icon = theme_path .. "icons/volume/audio-volume-muted.svg"

theme.wireless_connected_icon = theme_path .. "icons/network-wireless-connected.svg"
theme.wireless_disconnected_icon = theme_path .. "icons/network-wireless-disconnected.svg"
theme.wired_connected_icon = theme_path .. "icons/network-wired-activated.svg"
theme.wired_disconnected_icon = theme_path .. "icons/network-wired-unavailable.svg"

theme.arrow_left_icon = theme_path .. "icons/go-previous.svg"
theme.arrow_right_icon = theme_path .. "icons/go-next.svg"
theme.icon_terminal = theme_path .. "icons/utilities-terminal.svg"

theme.icon_bluetooth = theme_path .. "icons/network-bluetooth.svg"
theme.icon_empty_notibox = theme_path .. "icons/mail-receive.svg"
theme.icon_clear_all = theme_path .. "icons/clear-all.svg"
theme.icon_camera = theme_path .. "icons/camera-photo.svg"
theme.icon_mic = theme_path .. "icons/audio-input-microphone.svg"
theme.icon_airplane = theme_path .. "icons/airplane-mode.svg"

theme.icon_system_power_off = theme_path .. "icons/system/system-shutdown.svg"
theme.icon_system_restart = theme_path .. "icons/system/system-restart.svg"
theme.icon_system_sleep = theme_path .. "icons/system/system-suspend.svg"
theme.icon_system_screen_lock = theme_path .. "icons/system/system-lock-screen.svg"
theme.icon_system_logout = theme_path .. "icons/system/system-log-out.svg"
theme.face_image = theme_path .. "icons/system/default.png"

theme.icon_bell = theme_path .. "icons/notifications.svg"
theme.icon_lock = theme_path .. "icons/lock.svg"
theme.icon_dark_mode = theme_path .. "icons/contrast.svg"
theme.icon_redshift = theme_path .. "icons/redshift-status-on.svg"

theme.icon_floating = theme_path .. "layouts/floating.svg"
theme.icon_fullscreen = theme_path .. "icons/view-fullscreen.svg"
theme.icon_screen = theme_path .. "icons/computer.svg"
theme.icon_crop = theme_path .. "icons/image-crop.svg"
theme.icon_window = theme_path .. "icons/window.svg"
theme.icon_add = theme_path .. "icons/add.svg"
theme.icon_minus = theme_path .. "icons/minus.svg"

-- Icons for notifications
theme.icon_screenhost_taken = theme_path .. "icons/64x64/camera-photo.svg"
theme.icon_noti_error = theme_path .. "icons/48x48/dialog-error.svg"
theme.icon_noti_info = theme_path .. "icons/48x48/dialog-information.svg"
theme.icon_bat_caution = theme_path .. "icons/48x48/battery-caution.svg"
theme.icon_recorder = theme_path .. "icons/48x48/camera-on.svg"

-- Taglist
--- Generate taglist squares:
-- local taglist_square_size = dpi(5)
-- theme.taglist_font = theme.taglist_font
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, colors.blue
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, colors.yellow
-- )
theme.taglist_bg_focus = colors.transparent
theme.taglist_fg_focus = colors.blue
theme.taglist_fg_occupied = colors.yellow
theme.taglist_fg_urgent = colors.red
theme.taglist_bg_urgent = colors.transparent
-- theme.taglist_shape_border_width = dpi(0)
-- theme.taglist_shape_border_width_focus = dpi(1)
-- theme.taglist_shape_border_color_focus = colors.blue
-- theme.taglist_shape_border_color = colors.transparent
theme.taglist_spacing = dpi(2)

-- Tasklist
theme.tasklist_shape  = theme.panel_button_shape
theme.tasklist_shape_border_width = theme.button_panel_border_width
theme.tasklist_shape_border_color = theme.border_panel_button
theme.tasklist_bg_focus = colors.blue
if theme.mode  == "dark" then
    theme.tasklist_bg_normal = colors.dark_gray
elseif theme.mode == "glassy" then
    theme.tasklist_bg_normal = colors.gray
end
theme.tasklist_bg_minimize = colors.transparent

-- Snap area
theme.snap_bg = colors.bg .. "55"
theme.snap_shape = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 0)
end
theme.snap_border_width = dpi(3)

-- Notification
theme.notification_font = theme.font
theme.notification_bg = colors.bg
theme.notification_fg = colors.fg
theme.notification_width = dpi(265)
theme.notification_max_width = dpi(265)
theme.notification_icon_size = 64
theme.notification_spacing = dpi(8)
theme.notification_border_width = 0;

-- systray
theme.bg_systray = nil

-- Menu
theme.menu_submenu_icon = theme_path.."/submenu.png"
theme.menu_height = dpi(26)
theme.menu_width  = dpi(200)

-- Wibar
theme.wibar_height = dpi(28)
theme.wibar_position = "bottom"
theme.wibar_icon_size = dpi(16)

-- Titlebar
--- Define the image to load
theme.titlebar_close_button_normal = theme_path .. "/titlebar/window-close-normal.svg"
theme.titlebar_close_button_focus  = theme_path .. "/titlebar/window-close.svg"

theme.titlebar_minimize_button_normal = theme_path .. "/titlebar/go-down.svg"
theme.titlebar_minimize_button_focus  = theme_path .. "/titlebar/go-down.svg"


theme.titlebar_maximized_button_normal_inactive = theme_path.."/titlebar/go-up.svg"
theme.titlebar_maximized_button_focus_inactive  = theme_path.."/titlebar/go-up.svg"
theme.titlebar_maximized_button_normal_active = theme_path.."/titlebar/go-up.svg"
theme.titlebar_maximized_button_focus_active  = theme_path.."/titlebar/go-up.svg"
theme.titlebar_bg_focus = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_normal

-- Wallpaper and lock screen background
theme.wallpaper = theme_path.."/background.png"
theme.wallpaper_blur = theme_path.."/background-blur.png" -- Used for lock screen background

-- LayoutBox
--- You can use your own layout icons like this:
theme.layout_floating  = theme_path.."layouts/floating.svg"
theme.layout_max = theme_path.."layouts/max.svg"
theme.layout_fullscreen = theme_path.."layouts/fullscreen.svg"
theme.layout_tile = theme_path.."layouts/tile.svg"
theme.layout_dwindle = theme_path.."layouts/dwindle.svg"

-- Hotkey popup
theme.hotkeys_border_width = dpi(1)
theme.hotkeys_border_color = colors.bg
theme.hotkeys_modifiers_fg = colors.bg_alt
theme.hotkeys_shape = gears.shape.rounded_rect

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, colors.blue, colors.fg
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.

theme.icon_theme = ""

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
