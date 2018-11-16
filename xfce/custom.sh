#!/bin/bash

_g="\e[32;1m";_e="\e[m";_w="\e[37;1m";_y="\e[33;1m";

echo -e "${_y}Instalando programas pacman\n${_e}"

# programas normais
program=(
    'galculator'
    #'mysql-workbench'
    'gnome-keyring'
    'git'
    'flatpak'
    'engrampa'
)

for list in "${program[@]}"; do
    echo "==> Instalando programa: ${list}"; sleep 0.5
    #pacman -S ${list} --noconfirm
done

echo -e "\n${_y}Instalando programas flatpak\n${_e}"

# flatpaks
flatpak=(
    'com.axosoft.GitKraken'
    'com.discordapp.Discord'
    'org.qbittorrent.qBittorrent'
    'org.telegram.desktop'
    'org.videolan.VLC'
    'org.remmina.Remmina'
    'org.filezillaproject.Filezilla'
)

for list_flatpak in "${flatpak[@]}"; do
    echo "==> Instalando programa: ${list_flatpak}"; sleep 0.5
    #flatkpak install ${list_flatpak}
done

# AUR

# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -si

