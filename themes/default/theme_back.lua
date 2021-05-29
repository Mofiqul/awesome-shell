local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir () .. "themes/default/"
local theme = {}
theme.font = "Ubuntu 10"
theme.font_bold = "Ubuntu 10"
theme.font_large = "Ubuntu 12"
theme.font_large_bold = "Ubuntu bold 12"
theme.font_small =  "Ubuntu 9"
theme.font_extra_small =  "Ubuntu 9"


theme.bg_transparent = "#00000000"
theme.bg_normal     = "#252526EE"
theme.bg_normal_alt = "#767676"
theme.bg_focus      = "#0A7ACA"
theme.bg_urgent     = "#F44747"
theme.bg_minimize   = "#303030EE"
theme.bg_inner_widget = "#323232"

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- button colors
theme.bg_button = "#424242"
theme.bg_panel_button = theme.bg_transparent
theme.bg_panel_button_active = theme.bg_button
theme.border_button = theme.bg_button -- "#51514f"
theme.border_panel_button = theme.bg_transparent
theme.border_panel_button_active = theme.border_button
theme.button_active = "#0A7ACA"
theme.button_active_alt = "#2ea043"
theme.bg_tasklist_active = "#0A7ACA33"
theme.bg_tasklist_inactive = "#303030EE"
theme.useless_gap   = dpi(1)
theme.gap_single_client = true
theme.maximized_hide_border = true
theme.border_width  = dpi(1)
theme.button_panel_border_width = dpi(0)
theme.button_panel_border_width_active = dpi(1)
theme.border_normal = "#3d3d3d"
theme.border_focus  = "#0A7ACA"
theme.border_marked = "#F44747"
theme.bg_yellow = "#f36351"
-- Margins and paddings and border width
theme.notification_margin = dpi(6)
theme.widget_margin = dpi(6)
theme.btn_xs_margin = dpi(3)
theme.btn_md_margin = dpi(5)
theme.btn_border_width = dpi(1)
theme.widget_border_width = dpi(1)
theme.widget_margin = dpi(6)
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
    gears.shape.rounded_rect(cr, height, width, 12)
end

theme.widget_shape_alt = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 6)
end

theme.panel_button_shape = nil

theme.panel_button_shape_active = gears.shape.rounded_bar
-- Icons
theme.icon_times = themes_path .. "icons/remove.svg"
-- awesome icon 
theme.awesome_menu_icon = themes_path .. "icons/awesome.svg"
--- Update toggle icons
theme.icon_update_none = themes_path .. "icons/update-none.svg"
theme.icon_update_available = themes_path .."icons/update-low.svg"
--- Previous and Next icon
theme.icon_previous = themes_path .. "icons/go-previous.svg"
theme.icon_next = themes_path .. "icons/go-next.svg"

theme.icon_focus_mode = themes_path .. "icons/focus-mode.svg"

theme.brightness_icon = themes_path .. "icons/brightness.svg"

theme.battery_icon = themes_path .. "icons/battery/battery-normal.svg"
theme.battery_icon_charging = themes_path .. "icons/battery/battery-charging.svg"
theme.icon_ac = themes_path .. "icons/battery/ac.svg"
theme.volume_normal_icon = themes_path .. "icons/volume/audio-volume-high.svg"
theme.volume_muted_icon = themes_path .. "icons/volume/audio-volume-muted.svg"

theme.wireless_connected_icon = themes_path .. "icons/network-wireless-connected.svg"
theme.wireless_disconnected_icon = themes_path .. "icons/network-wireless-disconnected.svg"
theme.wired_connected_icon = themes_path .. "icons/network-wired-activated.svg"
theme.wired_disconnected_icon = themes_path .. "icons/network-wired-unavailable.svg"

theme.arrow_left_icon = themes_path .. "icons/go-previous.svg"
theme.arrow_right_icon = themes_path .. "icons/go-next.svg"
theme.icon_terminal = themes_path .. "icons/utilities-terminal.svg"

theme.icon_bluetooth = themes_path .. "icons/network-bluetooth.svg"
theme.icon_empty_notibox = themes_path .. "icons/mail-receive.svg"
theme.icon_clear_all = themes_path .. "icons/clear-all.svg"
theme.icon_camera = themes_path .. "icons/camera-photo.svg"
theme.icon_mic = themes_path .. "icons/audio-input-microphone.svg"
theme.icon_airplane = themes_path .. "icons/airplane-mode.svg"

theme.icon_system_power_off = themes_path .. "icons/system/system-shutdown.svg"
theme.icon_system_restart = themes_path .. "icons/system/system-restart.svg"
theme.icon_system_sleep = themes_path .. "icons/system/system-suspend.svg"
theme.icon_system_screen_lock = themes_path .. "icons/system/system-lock-screen.svg"
theme.icon_system_logout = themes_path .. "icons/system/system-log-out.svg"
theme.face_image = themes_path .. "icons/system/default.png"

theme.icon_bell = themes_path .. "icons/notifications.svg"
theme.icon_lock = themes_path .. "icons/lock.svg"
theme.icon_dark_mode = themes_path .. "icons/contrast.svg"
theme.icon_redshift = themes_path .. "icons/redshift-status-on.svg"

theme.icon_floating = themes_path .. "layouts/floating.svg"
theme.icon_fullscreen = themes_path .. "icons/view-fullscreen.svg"
theme.icon_screen = themes_path .. "icons/computer.svg"
theme.icon_crop = themes_path .. "icons/image-crop.svg"
theme.icon_window = themes_path .. "icons/window.svg"
theme.icon_add = themes_path .. "icons/add.svg"
theme.icon_minus = themes_path .. "icons/minus.svg"

-- Icons for notifications
theme.icon_screenhost_taken = themes_path .. "icons/64x64/camera-photo.svg"
theme.icon_noti_error = themes_path .. "icons/48x48/dialog-error.svg"
theme.icon_noti_info = themes_path .. "icons/48x48/dialog-information.svg"
theme.icon_bat_caution = themes_path .. "icons/48x48/battery-caution.svg"
theme.icon_recorder = themes_path .. "icons/48x48/camera-on.svg"
-- Taglist
--- Generate taglist squares:
local taglist_square_size = dpi(5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_bg_focus = theme.bg_transparent
theme.taglist_fg_focus = theme.bg_focus
theme.taglist_fg_urgent = theme.bg_urgent
theme.taglist_bg_urgent = theme.bg_transparent
theme.taglist_spacing     = dpi(2)


-- Tasklist
theme.tasklist_shape  = theme.panel_button_shape
theme.tasklist_shape_border_width = theme.button_panel_border_width
theme.tasklist_shape_border_color = theme.border_panel_button
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_normal = theme.border_button
theme.tasklist_bg_minimize = theme.bg_transparent


-- Snap area
theme.snap_bg = theme.bg_button
theme.snap_shape = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 8)
end
theme.snap_border_width = dpi(3)
theme.snapper_gap = dpi(3)


-- Notification
theme.notification_font = theme.font
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_shape = function (cr, height, width)
    gears.shape.rounded_rect(cr, height, width, 6)
end
theme.notification_width = dpi(265)
theme.notification_max_width = dpi(265)
theme.notification_icon_size = 64
theme.notification_spacing = dpi(8)
theme.notification_border_width = 0;
--theme.notification_border_color  = theme.border_normal


-- systray
theme.bg_systray = nil

-- Menu
theme.menu_submenu_icon = themes_path.."/submenu.png"
theme.menu_height = dpi(26)
theme.menu_width  = dpi(200)

-- Wibar
theme.wibar_height = dpi(28)
theme.wibar_position = "bottom"
theme.wibar_icon_size = dpi(16)

-- Titlebar
--- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "/titlebar/window-close-normal.svg"
theme.titlebar_close_button_focus  = themes_path .. "/titlebar/window-close.svg"

theme.titlebar_minimize_button_normal = themes_path .. "/titlebar/go-down.svg"
theme.titlebar_minimize_button_focus  = themes_path .. "/titlebar/go-down.svg"


theme.titlebar_maximized_button_normal_inactive = themes_path.."/titlebar/go-up.svg"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."/titlebar/go-up.svg"
theme.titlebar_maximized_button_normal_active = themes_path.."/titlebar/go-up.svg"
theme.titlebar_maximized_button_focus_active  = themes_path.."/titlebar/go-up.svg"
theme.titlebar_bg_focus = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_normal


theme.wallpaper = themes_path.."/background.png"
theme.wallpaper_blur = themes_path.."/background-blur.png"

-- LayoutBox
--- You can use your own layout icons like this:
theme.layout_floating  = themes_path.."layouts/floating.svg"
theme.layout_max = themes_path.."layouts/max.svg"
theme.layout_fullscreen = themes_path.."layouts/fullscreen.svg"
theme.layout_tile = themes_path.."layouts/tile.svg"
theme.layout_dwindle = themes_path.."layouts/dwindle.svg"


-- Hotkey popup
theme.hotkeys_border_width = dpi(1)
theme.hotkeys_border_color = theme.bg_normal
theme.hotkeys_modifiers_fg = theme.button_active_alt
theme.hotkeys_shape = gears.shape.rounded_rect

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.

theme.icon_theme = ""

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
