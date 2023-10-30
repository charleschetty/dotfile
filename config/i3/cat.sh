feh ~/Pictures/cutppuccin.png --bg-fill

cp ~/.config/alacritty/alacritty-cat.yml ~/.config/alacritty/alacritty.yml

cp ~/.config/nvim/lua/user/colorscheme-cat.lua ~/.config/nvim/lua/user/colorscheme.lua

cp ~/.config/nvim/lua/user/lualine-cat.lua ~/.config/nvim/lua/user/lualine.lua

cp ~/.gtkrc-2.0-cat ~/.gtkrc-2.0

cp ~/.config/bat/config-cat ~/.config/bat/config

cp ~/.config/bottom/bottom-cat.toml ~/.config/bottom/bottom.toml

cp ~/.config/dunst/dunstrc-cat ~/.config/dunst/dunstrc

cp ~/.config/fcitx5/conf/classicui-cat.conf ~/.config/fcitx5/conf/classicui.conf

cp ~/.config/gitui/theme-cat.ron ~/.config/gitui/theme.ron

cp ~/.config/gtk-3.0/settings-cat.ini ~/.config/gtk-3.0/settings.ini

cp ~/.config/gtk-4.0/gtk-dark-cat.css ~/.config/gtk-4.0/gtk-dark.css 

cp ~/.config/gtk-4.0/gtk-cat.css ~/.config/gtk-4.0/gtk.css

cp ~/.config/polybar/config-cat.ini ~/.config/polybar/config.ini

sh ~/.config/polybar/launch.sh 

cp ~/.config/rofi/config-cat.rasi ~/.config/rofi/config.rasi 

cp ~/.config/zathura/zathurarc-cat ~/.config/zathura/zathurarc

cp ~/.config/xob/styles-cat.cfg ~/.config/xob/styles.cfg

cp ~/.config/Kvantum/kvantum-cat.kvconfig ~/.config/Kvantum/kvantum.kvconfig

pkill fcitx5

fcitx5 & diswon

pkill xob

sh ~/.config/i3/start.sh

pkill dunst
