#!/bin/bash

echo "Configure Fedora v1.0"

#Config
hostnamectl set-hostname relluem94
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false



echo "add:"
echo "max_parallel_downloads=15"
echo "fastestmirror=true"
echo "deltarpm=true"
sudo xdg-open /etc/dnf/dnf.conf


#Installs
sudo dnf update -y --refresh
sudo dnf upgrade -y
sudo dnf install -y wget remmina google-chrome ranger vim gnome-tweak-tool gnome-extensions-app dnf-plugins-core chrome-gnome-shell arc-theme vlc wine unzip VirtualBox git git-lfs xournalpp java-11-openjdk  java-11-openjdk-devel openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome youtube-dl keepassxc lutris shotcut ranger htop
sudo dnf remove -y fedora-chromium-config

flatpak install -y steam discord Sequeler signal


curl -O https://downloads.apache.org/netbeans/netbeans/12.4/Apache-NetBeans-12.4-bin-linux-x64.sh
chmod +x Apache-NetBeans-12.4-bin-linux-x64.sh
sudo ./Apache-NetBeans-12.4-bin-linux-x64.sh

cat <<EOF > ~/.local/share/applications/netbeans.desktop
[Desktop Entry]
Name=Netbeans
Exec=netbeans
Icon=/usr/share/applications/netbeans.png
Terminal=false
Type=Application
Categories=Development"
EOF

rm -f Apache-NetBeans-12.4-bin-linux-x64.sh




#Extensions
xdg-open https://extensions.gnome.org/extension/3628/arcmenu/
xdg-open https://extensions.gnome.org/extension/779/clipboard-indicator/
xdg-open https://extensions.gnome.org/extension/3396/color-picker/
xdg-open https://extensions.gnome.org/extension/1082/cpufreq/
xdg-open https://extensions.gnome.org/extension/1160/dash-to-panel/
xdg-open https://extensions.gnome.org/extension/4135/espresso/
xdg-open https://extensions.gnome.org/extension/841/freon/
xdg-open https://extensions.gnome.org/extension/4099/no-overview/
xdg-open https://extensions.gnome.org/extension/708/panel-osd/
xdg-open https://extensions.gnome.org/extension/19/user-themes/
xdg-open https://extensions.gnome.org/extension/36/lock-keys/
