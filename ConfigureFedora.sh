#!/bin/bash

###########################################################################################
#                                       Configure Fedora                                  #
#                                      by Relluem94 2023                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
version="v1.1";
SPACER="================================================================================"
#
#
#
###########################################################################################
#                                               Config                                    #
###########################################################################################
echo $SPACER 
echo " "
echo "Configure Fedora $version"
echo " "
echo $SPACER 
echo " "
echo " "
echo "Enter Hostname:"
read hostname
echo "Setting Hostname to: $hostname"
hostnamectl set-hostname $hostname
echo " "
echo "Adding Flatpak Repo"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo " "
echo "Setting Window Button Layout"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
echo " "
echo "Setting Mouse Natural Scroll to false"
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false
echo " "
echo "Uncommenting WaylandEnable=false in /etc/gdm/custom.conf"
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/g' /etc/gdm/custom.conf
echo " "
echo "Please add the following options (if not already set):"
echo "max_parallel_downloads=15"
echo "fastestmirror=true"
echo "deltarpm=true"
sudo xdg-open /etc/dnf/dnf.conf
echo " "
echo " "
echo " "
echo " "
###########################################################################################
#                                            Installs                                     #
###########################################################################################
echo $SPACER
echo " "
echo "Install"
echo " "
echo $SPACER
echo " "
echo " "
echo "Updating Fedora"
sudo dnf upgrade -y --refresh
echo " "
echo "Installing Packages"
sudo dnf install -y wget tmux remmina ranger vim gnome-tweak-tool gnome-extensions-app dnf-plugins-core stacer guake chrome-gnome-shell arc-theme \
vlc wine unzip VirtualBox git git-lfs gitk xournalpp java-11-openjdk  java-11-openjdk-devel flameshot dolphin \
openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome youtube-dl keepassxc lutris shred shotcut ranger htop python3-pip parallel pavucontrol qrencode
echo " "
echo "Removing Chromium Config (shows Company Managed in Browser)"
sudo dnf remove -y fedora-chromium-config
echo " "
echo "Installing Flatpak Packages"
flatpak install -y steam discord Sequeler signal
echo " "
echo "Installing pip Packages"
pip install speedtest-cli
echo " "
echo "Adding VSCodium Repo"
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
echo " "
echo "Installing VSCodium"
sudo dnf install codium -y
echo " "
echo "Removing Preinstalled Docker"
###########################################################################################
#                                               Docker                                    #
###########################################################################################
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine -y 
echo " "
echo "Installing Docker"
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
echo " "
echo "Starting Docker"
sudo systemctl start docker
echo " "
echo "Enable Docker on System start"
sudo systemctl enable docker
echo " "
echo "Adding Docker User"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
###########################################################################################
#                                         Docker Images                                   #
###########################################################################################
echo " "
echo "Running MySQL 8.0 Docker"
docker run --name=mysql --restart on-failure -d mysql/mysql-server:8.0 -p 3306:3306
echo " "
echo " Execute the following commands later:"
echo " "
echo "================================= MYSQL PASSWORD ================================="
docker logs mysql 2>&1 | grep GENERATED # MYSQL Password 
echo "docker exec -it mysql mysql -uroot -p"
echo "ALTER USER 'root'@'%' IDENTIFIED BY 'nqSK3JMd0DL0OLggCDTjHRu8S1UTrCVbCuTr1uV9VU';"
echo "FLUSH PRIVILEGES;"
echo "================================= MYSQL PASSWORD ================================="
echo " "
echo " "
echo " "
echo "Running phpMyAdmin Docker"
docker volume create phpmyadmin-volume
docker run --name phpmyadmin -v phpmyadmin-volume:/etc/phpmyadmin/config.user.inc.php --link mysql:db -p 88:80 -d phpmyadmin/phpmyadmin
echo " "
echo " "
echo " "
echo " "
###########################################################################################
#                                            Keyboard Shortcuts                           #
###########################################################################################
echo $SPACER
echo " "
echo "Keybindings"
echo " "
echo $SPACER
echo " "
echo " "
echo "Setting 4 Custom Keybindings"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"
echo " "
echo "Setting #0 <F7> flameshot gui clipboard"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Screenshot Clipboard'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'F7'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot gui --clipboard'
echo " "
echo "Setting #1 <F6> flameshot gui"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Screenshot Path'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'F6'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flameshot gui'
echo " "
echo "Setting #2 <SUPER+E> nautilus (File Manager)"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Nautilus'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Super>E'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'nautilus'
echo " "
echo "Setting #3 <ALT+T> gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Alt>T'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'gnome-terminal'
###########################################################################################
#                       Copy Configs/Templates/Scripts, Configure tmux                    #
###########################################################################################
echo $SPACER
echo " "
echo "Copy Configs/Templates/Scripts, Configure tmux"
echo " "
echo $SPACER
echo " "
echo " "
echo "copy bash Config"
cp .bashrc ~/.bashrc
echo " "
echo "tmux Config"
cp .tmux.conf ~/.tmux.conf
echo " "
echo "cloning tmux pluginmanager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo " "
echo "cloning tmux cpu plugin"
git clone https://github.com/tmux-plugins/tmux-cpu ~/.tmux/plugins/tmux-cpu
echo " "
echo "Execute Nautilus Config (./snippets/CopyFileManagerScriptsAndTemplates.sh)"
sh ./snippets/CopyFileManagerScriptsAndTemplates.sh
echo " "
echo " "
echo " "
echo " "
###########################################################################################
#                                      GNOME Extensions                                   #
###########################################################################################
echo $SPACER
echo " "
echo "GNOME Extensions"
echo " "
echo $SPACER
echo " "
echo " "
echo "Opening some GNOME Extenions:"
xdg-open https://extensions.gnome.org/extension/3628/arcmenu/
xdg-open https://extensions.gnome.org/extension/4412/advanced-alttab-window-switcher/
xdg-open https://extensions.gnome.org/extension/4012/gnome-bedtime/
xdg-open https://extensions.gnome.org/extension/3952/workspace-indicator/
xdg-open https://extensions.gnome.org/extension/1319/gsconnect/
xdg-open https://extensions.gnome.org/extension/779/clipboard-indicator/
xdg-open https://extensions.gnome.org/extension/3396/color-picker/
xdg-open https://extensions.gnome.org/extension/1160/dash-to-panel/
xdg-open https://extensions.gnome.org/extension/517/caffeine/
xdg-open https://extensions.gnome.org/extension/841/freon/
xdg-open https://extensions.gnome.org/extension/4099/no-overview/
xdg-open https://extensions.gnome.org/extension/19/user-themes/
xdg-open https://extensions.gnome.org/extension/36/lock-keys/
echo " "
echo " "
echo " "
echo " "
###########################################################################################
#                                            Finished                                     #
###########################################################################################
echo $SPACER
echo " "
echo "Finished Installation and Configuration!"
echo " "
echo $SPACER
echo " "
echo " "
