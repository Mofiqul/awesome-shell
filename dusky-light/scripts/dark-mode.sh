#!/bin/sh
# Change awesome theme
rm -rf $HOME/.config/awesome ; ln -s $HOME/Projects/awesome-config/dusky $HOME/.config/awesome

echo '
Xft/Hinting 1
Xft/HintStyle "hintslight"
Xft/Antialias 1
Xft/RGBA "rgb"
Net/ThemeName "Fluent-dark"
Gtk/CursorThemeName "Adwaita"
Net/IconThemeName "Qogir-dark"
' > ~/.xsettingsd

# Set Kitty thmeme
kitty @ set-colors -a -c "$HOME/.config/kitty/themes/codeDark.conf"

# Set vim colorcheme
echo "vim.cmd[[colorscheme codedark]]" > "$HOME/.config/nvim/lua/set-colorscheme.lua"
# Reload gtk theme
killall -HUP xsettingsd
