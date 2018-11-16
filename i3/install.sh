__A=$(echo -e "\e[34;1m");__O=$(echo -e "\e[m");_g="\e[32;1m";_e="\e[m";_w="\e[37;1m";_y="\e[33;1m";

[ "$EUID" -ne 0 ] && echo -e "${_y}É necessário rodar o script como root!${_e}\n${_g}Use:${_e} ${_w}sudo ./install.sh${_e}" && exit 1

echo -en "${_g}Você está instalando em uma VM? Didigte S para (Sim) ou N para (Não):${_e}${_w} "; read _vm
[[ "$_vm" != @(s|S|n|N) ]] && { echo -e "\n${_y}Digite uma opção válida! s/S ou n/N\n${_e}"; exit 1; }

if [[ "$_vm" == @(s|S) ]]; then
	_virtualbox="s"
elif [[ "$_vm" == @(n|N) ]]; then
	echo -en "${_g}Você está instalando em um notebook?  Didigte S para (Sim) ou N para (Não)${_e}:${_w} "; read _not
	[[ "$_not" != @(s|S|n|N) ]] && { echo -e "\n${_y}Digite uma opção válida! s/S ou n/N\n${_e}"; exit 1; }
	if [[ "$_not" == @(s|S) ]]; then
		_notebook="s"
	fi
fi

echo

tput reset

cat <<STI
${__A}=========================
Iniciando a Instalação i3
=========================${__O}
STI

echo -e "\nVocê está instalando xfce com suporte de drivers para:\n"

if [ "$_notebook" == "s" ]; then
	echo -e "${_y}Notebook${_e}"
elif [ "$_virtualbox" == "s" ]; then
	echo -e "${_y}VM (máquina virtual)${_e}"
else
	echo -e "${_y}PC${_e}"
fi

echo -e "${_g}==> Instando xorg${_e}"; sleep 1
pacman -S xorg-xinit xorg-server xf86-input-keyboard xf86-input-mouse xf86-video-vesa --noconfirm

if [ "$_notebook" == "s" ]; then # notebook
	echo -e "${_g}==> Instalando drivers para notebook${_e}"; sleep 1
	pacman -S xf86-input-synaptics xf86-input-libinput wireless_tools wpa_supplicant wpa_actiond acpi acpid --noconfirm; sleep 1
	echo -e "${_g}==> Configurando tap-to-click${_e}"; sleep 1
	curl -s -o /etc/X11/xorg.conf.d/30-touchpad.conf 'https://raw.githubusercontent.com/leoarch/arch-linux/master/xfce/xorg.conf.d/touchpad'
elif [ "$_virtualbox" == "s" ]; then # virtualbox
	echo -e "${_g}==> Guest Utils Virtuabox${_e}"; sleep 1
	pacman -S virtualbox-guest-utils --noconfirm
fi

echo -e "${_g}==> Instalando i3${_e}"; sleep 1
pacman -S i3-gaps i3blocks --noconfirm

echo -e "${_g}==> Instalando fontes e terminal${_e}"; sleep 1 # mude de acordo com suas necessidades
pacman -S terminus-font ttf-dejavu termite gvfs --noconfirm

# firefox
echo -e "${_g}==> Instalando firefox${_e}"; sleep 1
pacman -S firefox firefox-i18n-pt-br flashplugin --noconfirm

# audio
echo -e "${_g}==> Instalando audio${_e}"; sleep 1
pacman -S alsa-utils pulseaudio pavucontrol --noconfirm

# network
echo -e "${_g}==> Instalando utilitários de rede${_e}"; sleep 1
pacman -S networkmanager network-manager-applet --noconfirm

# criar diretórios
echo -e "${_g}==> Criando diretórios{_e}"; sleep 1
pacman -S xdg-user-dirs --noconfirm && xdg-user-dirs-update

# iniciar i3
echo -e "${_g}==> Configurando pra iniciar o i3${_e}"; sleep 1
echo 'exec i3' > ~/.xinitrc

# keyboard X11 br abnt2
echo -e "${_g}==> Setando keymap br abnt2 no ambiente X11${_e}"; sleep 1
localectl set-x11-keymap br abnt2

# keyboard
echo -e "${_g}==> Criando arquivo de configuração para keyboard br abnt${_e}"; sleep 1
curl -s -o /etc/X11/xorg.conf.d/10-evdev.conf 'https://raw.githubusercontent.com/leoarch/arch-linux/master/xfce/xorg.conf.d/keyboard'

# configurando lightdm
echo -e "${_g}==> Configurando gerenciador de login lightdm${_e}"; sleep 1
sed -i 's/^#greeter-session.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
sed -i '/^#greeter-hide-user=/s/#//' /etc/lightdm/lightdm.conf
curl -s -o /usr/share/pixmaps/bg-lightdm.jpg 'https://raw.githubusercontent.com/leoarch/arch-linux/master/xfce/bg-lightdm.jpg'
echo -e "[greeter]\nbackground=/usr/share/pixmaps/bg-lightdm.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf

# enable services
echo -e "${_g}==> Habilitando serviços para serem iniciados com o sistema${_e}"; sleep 1
systemctl enable lightdm
systemctl enable NetworkManager

cat <<EOI
${__A}===
FIM!    
====${__O}
EOI