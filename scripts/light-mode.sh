#!/bin/sh
rm -rf $HOME/.config/awesome ; ln -s $HOME/Projects/awesome-config/dusky-light $HOME/.config/awesome

echo '
Xft/Hinting 1
Xft/HintStyle "hintslight"
Xft/Antialias 1
Xft/RGBA "rgb"
Net/ThemeName "Fluent-light"
Gtk/CursorThemeName "Adwaita"
Net/IconThemeName "Qogir"
' > ~/.xsettingsd
# Set Kitty thmeme
kitty @ set-colors -a -c "$HOME/.config/kitty/themes/codeLight.conf"
# Set vim colorcheme
echo "vim.cmd[[colorscheme codelight]]" > $HOME/.config/nvim/lua/set-colorscheme.lua

killall -HUP xsettingsd

