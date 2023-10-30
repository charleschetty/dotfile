feh ~/Pictures/nord1.png --bg-fill

cp ~/.config/alacritty/alacritty-nord.yml ~/.config/alacritty/alacritty.yml

cp ~/.config/nvim/lua/user/colorscheme-nord.lua ~/.config/nvim/lua/user/colorscheme.lua

cp ~/.config/nvim/lua/user/lualine-nord.lua ~/.config/nvim/lua/user/lualine.lua

cp ~/.gtkrc-2.0-nord ~/.gtkrc-2.0

cp ~/.config/bat/config-nord ~/.config/bat/config

cp ~/.config/bottom/bottom-nord.toml ~/.config/bottom/bottom.toml

cp ~/.config/dunst/dunstrc-nord ~/.config/dunst/dunstrc

cp ~/.config/fcitx5/conf/classicui-nord.conf ~/.config/fcitx5/conf/classicui.conf

cp ~/.config/gitui/theme-nord.ron ~/.config/gitui/theme.ron

cp ~/.config/gtk-3.0/settings-nord.ini ~/.config/gtk-3.0/settings.ini

cp ~/.config/gtk-4.0/gtk-dark-nord.css ~/.config/gtk-4.0/gtk-dark.css 

cp ~/.config/gtk-4.0/gtk-nord.css ~/.config/gtk-4.0/gtk.css

cp ~/.config/polybar/config-nord.ini ~/.config/polybar/config.ini

sh ~/.config/polybar/launch.sh 

cp ~/.config/rofi/config-nord.rasi ~/.config/rofi/config.rasi 

cp ~/.config/zathura/zathurarc-nord ~/.config/zathura/zathurarc

cp ~/.config/xob/styles-nord.cfg ~/.config/xob/styles.cfg

cp ~/.config/Kvantum/kvantum-nord.kvconfig ~/.config/Kvantum/kvantum.kvconfig

pkill fcitx5

fcitx5 & diswon

pkill xob

sh ~/.config/i3/start.sh

pkill dunst
