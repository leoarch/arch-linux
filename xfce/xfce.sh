#!/bin/bash

### INSTALANDO XFCE ###

__A=$(echo -e "\e[34;1m");__O=$(echo -e "\e[m");_g="\e[32;1m";_o="\e[m";_w="\e[37;1m";_am="\e[33;1m";

[ "$EUID" -ne 0 ] && echo -e "${_am}É necessário rodar o script como root!${_o}\n${_g}Use:${_o} ${_w}sudo ./xfce.sh${_o}" && exit 1

echo -en "\n${_g}Qual o nome do seu usuário:${_w} "; read _user
echo
echo -en "\n${_g}Você está instalando em um notebook?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "; read _laptop
echo
echo -en "\n${_g}Você está instalando em uma VM?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "; read _vm

if [[ "$_laptop" == @(S|s) ]]; then
	_notebook="s"
fi

if [[ "$_vm" == @(S|s) ]]; then
	_virtualbox="s"
fi

tput reset

cat <<STI
 ${__A}===========================
 Iniciando a Instalação xfce
 ===========================${__O}
STI

# xorg
echo -e "${_g}==>Instalando xorg${_o}"; sleep 1
pacman -S xorg-xinit xorg-server xf86-input-keyboard xf86-input-mouse xf86-video-vesa --noconfirm

# notebook
if [ "$_notebook" == "s" ]; then
	pacman -S xf86-input-synaptics xf86-input-libinput wireless_tools wpa_supplicant wpa_actiond acpi acpid --noconfirm; sleep 1
fi

# virtualbox
if [ "$_virtualbox" == "s" ]; then
	echo -e "${_g}==>Guest Utils Virtuabox${_o}"; sleep 1
	pacman -S virtualbox-guest-utils --noconfirm
fi

# xfce
echo -e "${_g}==>Instalando xfce e lightdm${_o}"; sleep 1
pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter --noconfirm

# firefox
echo -e "${_g}==>Instalando firefox${_o}"; sleep 1
pacman -S firefox firefox-i18n-pt-br flashplugin --noconfirm

# audio
echo -e "${_g}==>Instalando audio${_o}"; sleep 1
pacman -S alsa-utils pulseaudio pavucontrol --noconfirm

# network
echo -e "${_g}==>Instalando utilitários de rede${_o}"; sleep 1
pacman -S networkmanager network-manager-applet --noconfirm

# essenciais
echo -e "${_g}==>Instalando fonte, xterm e lixeira${_o}"; sleep 1
pacman -S ttf-dejavu xterm gvfs --noconfirm # gvfs = lixeira

# tema opcional
pacman -S numix-gtk-theme papirus-icon-theme --noconfirm

# criar diretórios
echo -e "${_g}==>Criando diretórios{_o}"; sleep 1
pacman -S xdg-user-dirs --noconfirm && xdg-user-dirs-update

# start xfce
echo -e "${_g}==>Configurando pra iniciar o xfce${_o}"; sleep 1
echo 'exec startxfce4' > ~/.xinitrc; sleep 1

# keyboard X11 br abnt2
echo -e "${_g}==>Setando keymap br abnt2 no ambiente X11${_o}"; sleep 1
localectl set-x11-keymap br abnt2

# configurando lightdm
echo -e "${_g}==>Configurando gerenciador de login lightdm${_o}"; sleep 1
sed -i 's/^#greeter-session.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
sed -i '/^#greeter-hide-user=/s/#//' /etc/lightdm/lightdm.conf
curl -s -o /usr/share/pixmaps/bg-lightdm.jpg 'https://raw.githubusercontent.com/leoarch/arch-install/master/bg-lightdm.jpg'
echo -e "[greeter]\nbackground=/usr/share/pixmaps/bg-lightdm.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf

# keyboard
if [[ "$_notebook" == "s" ]]; then
	curl -s -o /etc/X11/xorg.conf.d/30-touchpad.conf 'https://raw.githubusercontent.com/leoarch/arch-linux/master/xfce/xorg.conf.d/touchpad'
fi
curl -s -o /etc/X11/xorg.conf.d/10-evdev.conf 'https://raw.githubusercontent.com/leoarch/arch-linux/master/xfce/xorg.conf.d/keyboard'


echo -e "${_g}===>Removendo borda dos ícones do desktop${_o}"; sleep 1
curl -s -o /home/${_user}/.gtkrc-2.0 'https://raw.githubusercontent.com/leoarch/arch-linux/xfce/master/icon-desktop'


echo -e "${_g}===>Usando dhclient${_o}"; sleep 1
echo -e "[main]\ndhcp=dhclient" > /etc/NetworkManager/conf.d/dhclient.conf

# enable services
echo -e "${_g}==>Habilitando serviços para serem iniciados com o sistema${_o}"; sleep 1
systemctl enable lightdm
systemctl enable NetworkManager

cat <<EOI
 ${__A}=============
      FIM!    
 =============${__O}
EOI