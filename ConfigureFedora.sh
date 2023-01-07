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
sudo dnf install -y wget remmina ranger vim gnome-tweak-tool gnome-extensions-app dnf-plugins-core chrome-gnome-shell arc-theme \
vlc wine unzip VirtualBox git git-lfs gitk xournalpp java-11-openjdk  java-11-openjdk-devel flameshot \
openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome youtube-dl keepassxc lutris shred shotcut ranger htop python3-pip parallel pavucontrol 

sudo dnf remove -y fedora-chromium-config

flatpak install -y steam discord Sequeler signal

pip install speedtest-cli

sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo

sudo dnf install codium -y


cp .bashrc ~/.bashrc


#Keyboard Shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Screenshot Clipboard'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'F7'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot gui --clipboard'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Screenshot Path'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'F6'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flameshot gui'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Nautilus'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Super>E'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'nautilus'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Alt>T'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'gnome-terminal'


#Disable Wayland
echo "Disable Wayland"
sudoedit /etc/gdm/custom.conf


#Docker
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine -y 
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker


#Docker Images
docker run --name=mysql --restart on-failure -d mysql/mysql-server:8.0 -p 3306:3306


echo "================================= MYSQL PASSWORD ================================="
docker logs mysql 2>&1 | grep GENERATED # MYSQL Password 
echo "docker exec -it mysql mysql -uroot -p"
echo "ALTER USER 'root'@'%' IDENTIFIED BY 'nqSK3JMd0DL0OLggCDTjHRu8S1UTrCVbCuTr1uV9VU';"
echo "FLUSH PRIVILEGES;"
echo "================================= MYSQL PASSWORD ================================="


docker volume create phpmyadmin-volume
docker run --name phpmyadmin -v phpmyadmin-volume:/etc/phpmyadmin/config.user.inc.php --link mysql:db -p 88:80 -d phpmyadmin/phpmyadmin


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
