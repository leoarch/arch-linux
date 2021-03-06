#!/bin/bash

[ "$EUID" -eq 0 ] && echo -e "${_am}Não rode o script como root!${_o}" && exit 1

###########
### AUR ###
###########

sudo pacman -S go --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

################
### i3config ###
################

sudo pacman -S flatpak git leafpad rofi flameshot transmission-cli go feh xorg-xinput  # xorg-xinput
yay -S google-chrome --noconfirm

###########

# sublime-text
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg; sleep 1
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf; sleep 1
sudo pacman -Syu sublime-text --noconfirm

################
### i3config ###
################

# i3blocks
#sed -i 's/status_command i3status/status_command i3blocks -c ~\/.config\/i3\/i3blocks\/i3blocks.conf\n\tcolors {\n\t\tseparator #969896\n\t\tbackground #1d1f21\n\t\tstatusline #c5c8c6\n\t\tfocused_workspace #81a2be #81a2be #1d1f21\n\t\tactive_workspace#373b41 #373b41 #ffffff\n\t\tinactive_workspace#282a2e #282a2e #969896\n\t\turgent_workspace#cc6666 #cc6666 #ffffff\n\t}/' ~/.config/i3/config

# sed -i 's/status_command i3status/status_command i3blocks\n\tcolors {\n\t\tseparator #969896\n\t\tbackground #1d1f21\n\t\tstatusline #c5c8c6\n\t\tfocused_workspace #81a2be #81a2be #1d1f21\n\t\tactive_workspace#373b41 #373b41 #ffffff\n\t\tinactive_workspace#282a2e #282a2e #969896\n\t\turgent_workspace#cc6666 #cc6666 #ffffff\n\t}/' ~/.config/i3/config

# i3blocks config
# mkdir -p ~/.config/i3/i3blocks/
# curl -s -o ~/.config/i3/i3blocks/i3blocks.conf 'https://raw.githubusercontent.com/leoarch/arch-linux/master/i3/i3blocks.conf'

# gaps
echo -e '# gaps\nfor_window [class="^.*"] border pixel 2\ngaps inner 10\ngaps outer 10\n' >> ~/.config/i3/config

# google-chrome
echo -e '\n\n# chrome\nbindsym F1 exec --no-startup-id google-chrome-stable\nfor_window [class="chrome"] move to workspace $ws2\nassign [class="^chrome"] $ws2\n' >> ~/.config/i3/config

# flameshot
mkdir -p ~/Screenshots
echo -e '# flameshot\nbindsym Print exec --no-startup-id "flameshot gui -p ~/Screenshots\n' >> ~/.config/i3/config

# network-manager
echo -e '# network-manager\nexec --no-startup-id nm-applet\n' >> ~/.config/i3/config

# rofi
sed -i 's/dmenu_run/rofi -show drun/' ~/.config/i3/config

# mouse acceleration
echo -e '# mouse acceleration\nexec --no-startup-id xinput --set-prop 8 'libinput Accel Speed' -0.45\n' >> ~/.config/i3/config

# feh
mkdir -p ~/Imagens && mkdir -p ~/Imagens/wallpaper
cd ~/Imagens/wallpaper/
wget https://raw.githubusercontent.com/leoarch/arch-linux/master/i3/wallpaper/matrix-5.jpg
echo -e '# feh\nexec --no-startup-id feh --bg-scale /home/leo/Imagens/wallpaper/matrix-5.jpg\n' >> ~/.config/i3/config

#sudo ln -s /opt/sublime_text/sublime_text /usr/bin/
#obs
#E se quiser procurar alguma coisa que só aparece no run é só teclar ctrl+tab que o rofi alterna entre os modos

# chrome
#echo -e '\n# chrome\nbindsym $mod+Shift+f exec --no-startup-id google-chrome-stable\nfor_window [class="chrome"] move to workspace $ws2, floating enable, resize set 1450px 800px, move position center, focus\nassign [class="^chrome"] $ws2\n' >> ~/.config/i3/config

#deve estar onde vc deixou