#!/bin/bash

###########################################################################################
#                                        Configure Pi                                     #
#                                  by Relluem94 2024 - 2025                               #
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
version="v1.4";
SPACER="================================================================================"
#
#
#
###########################################################################################
#                                             Info                                        #
###########################################################################################

echo $SPACER 
echo " "
echo "Configure Pi $version"
echo " "
echo $SPACER 
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
echo "Updating Pi"
sudo apt update || { echo "Failed to update packages"; exit 1; }
sudo apt upgrade -y || { echo "Failed to upgrade packages"; exit 1; }

echo " "
echo "Installing Packages"

sudo apt install git tmux liferea ranger cec-utils ydotool wayfire lightdm || { echo "Failed to install packages"; exit 1; 

echo " "
echo "Copying bash config..."
if [ -f "../shared/config/.bashrc" ]; then
    cp ../shared/config/.bashrc ~/.bashrc
else
    echo "Warning: .bashrc not found at ../shared/config/.bashrc"
fi

echo " "
echo "Copying tmux config,..."
if [ -f "../shared/config/.tmux.conf" ]; then
    cp ../shared/config/.tmux.conf ~/.tmux.conf
else
    echo "Warning: .tmux.conf not found at ../shared/config/.tmux.conf"
fi

echo " "
echo "Cloning tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || { echo "Failed to clone tmux plugin manager"; exit 1; }

echo " "
echo "Cloning tmux CPU plugin..."
git clone https://github.com/tmux-plugins/tmux-cpu ~/.tmux/plugins/tmux-cpu || { echo "Failed to clone tmux CPU plugin"; exit 1; }

echo " "
echo "Installing RetroPie..."
cd ~/repos
git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git || { echo "Failed to clone RetroPie"; exit 1; }
cd RetroPie-Setup && sudo ./retropie_setup.sh

echo " "
echo "Copying cec_remote.service, cecremote.sh, and cecremotestart.sh..."
if [ -f "~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/cec_remote.service" ]; then
    sudo cp ~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/cec_remote.service /lib/systemd/system/cec_remote.service
else
    echo "Error: cec_remote.service not found at ~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/"
    exit 1
fi

if [ -f "~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/cecremote.sh" ]; then
    cp ~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/cecremote.sh ~/
else
    echo "Error: cecremote.sh not found at ~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/"
    exit 1
fi

if [ -f "~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/cecremotestart.sh" ]; then
    cp ~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/cecremotestart.sh ~/
else
    echo "Error: cecremotestart.sh not found at ~/repos/RelluBash-Script-Collection/distros/pi/cec_remote/"
    exit 1
fi


echo " "
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload || { echo "Failed to reload systemd"; exit 1; }

echo " "
echo "Enabling cec_remote.service..."
sudo systemctl enable cec_remote.service || { echo "Failed to enable cec_remote.service"; exit 1; }

echo " "
echo "Starting cec_remote.service..."
sudo systemctl start cec_remote.service || { echo "Failed to start cec_remote.service"; exit 1; }

echo " "
echo " "
echo " "
echo " "



###########################################################################################
#                                               Config                                    #
###########################################################################################
echo $SPACER
echo " "
echo "Configuration"
echo " "
echo $SPACER
echo " "
echo " "
echo "Enter Hostname (letters, numbers, hyphens only, press Enter to keep current hostname):"
read hostname
if [ -z "$hostname" ]; then
    echo "Keeping current hostname: $(hostname)"
else
    if [[ "$hostname" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo "Setting Hostname to: $hostname"
        sudo hostnamectl set-hostname "$hostname"
    else
        echo "Error: Invalid hostname. Keeping current hostname: $(hostname)"
    fi
fi

echo " "
echo "Setting up tmpfs for /var/log and /tmp..."
if ! grep -q "/var/log tmpfs" /etc/fstab; then
    echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,mode=0755,size=100m 0 0" | sudo tee -a /etc/fstab
fi
if ! grep -q "/tmp tmpfs" /etc/fstab; then
    echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=100m 0 0" | sudo tee -a /etc/fstab
fi

echo " "
echo "Disabling unnecessary logging in rsyslog..."
sudo sed -i 's/^\*.info/#*.info/' /etc/rsyslog.conf
sudo sed -i 's/^authpriv/#authpriv/' /etc/rsyslog.conf
sudo sed -i 's/^cron/#cron/' /etc/rsyslog.conf
sudo systemctl restart rsyslog || { echo "Failed to restart rsyslog"; exit 1; }

echo " "
echo "Disabling swap..."
sudo dphys-swapfile swapoff
sudo systemctl disable dphys-swapfile
sudo rm -f /var/swap

echo " "
echo "Setting up weekly TRIM..."
if ! grep -q "fstrim" /etc/crontab; then
    echo "@weekly /sbin/fstrim -v /" | sudo tee -a /etc/crontab
fi

echo " "
echo "Optimizing Retropie..."
RETROARCH_CFG="/home/$USER/.config/retroarch/retroarch.cfg"
if [ -f "$RETROARCH_CFG" ]; then
    if ! grep -q "log_verbosity = false" "$RETROARCH_CFG"; then
        echo "log_verbosity = false" | sudo tee -a "$RETROARCH_CFG"
    fi
    if ! grep -q "autosave = false" "$RETROARCH_CFG"; then
        echo "autosave = false" | sudo tee -a "$RETROARCH_CFG"
    fi
    if ! grep -q "savestate_auto_save = false" "$RETROARCH_CFG"; then
        echo "savestate_auto_save = false" | sudo tee -a "$RETROARCH_CFG"
    fi
fi

echo " "
echo "Optimizing Liferea..."
LIFEREA_CFG="/home/$USER/.config/liferea/liferea.rc"
if [ -d "/home/$USER/.config/liferea" ]; then
    mkdir -p /tmp/liferea_cache
    if [ -f "$LIFEREA_CFG" ]; then
        if ! grep -q "cache-folder=/tmp/liferea_cache" "$LIFEREA_CFG"; then
            echo "cache-folder=/tmp/liferea_cache" | tee -a "$LIFEREA_CFG"
        fi
        if ! grep -q "refresh-interval=60" "$LIFEREA_CFG"; then
            echo "refresh-interval=60" | tee -a "$LIFEREA_CFG"
        fi
    else
        echo "[liferea]" > "$LIFEREA_CFG"
        echo "cache-folder=/tmp/liferea_cache" >> "$LIFEREA_CFG"
        echo "refresh-interval=60" >> "$LIFEREA_CFG"
    fi
fi

echo " "
echo "Optimizing CEC service logging..."
CEC_SERVICE="/lib/systemd/system/cec_remote.service"
if [ -f "$CEC_SERVICE" ]; then
    if ! grep -q "StandardOutput=null" "$CEC_SERVICE"; then
        sudo sed -i '/\[Service\]/a StandardOutput=null' "$CEC_SERVICE"
        sudo sed -i '/\[Service\]/a StandardError=null' "$CEC_SERVICE"
        sudo systemctl daemon-reload
        sudo systemctl restart cec_remote.service
    fi
fi

echo " "
echo "Configuring hardware acceleration..."
if ! grep -q "dtoverlay=vc4-kms-v3d" /boot/config.txt; then
    echo "dtoverlay=vc4-kms-v3d" | sudo tee -a /boot/config.txt
fi
if ! grep -q "gpu_mem=128" /boot/config.txt; then
    echo "gpu_mem=128" | sudo tee -a /boot/config.txt
fi
if ! grep -q "hdmi_enable_cec=1" /boot/config.txt; then
    echo "hdmi_enable_cec=1" | sudo tee -a /boot/config.txt
fi

echo " "
echo "Applying noatime to root filesystem..."
if ! grep -q "noatime" /etc/fstab; then
    sudo sed -i 's/defaults/defaults,noatime/' /etc/fstab
fi

echo " "
echo "Configuring LightDM..."
if [ -f /etc/lightdm/lightdm.conf ]; then
    if ! grep -q "user-session=wayfire" /etc/lightdm/lightdm.conf; then
        echo "[Seat:*]" | sudo tee -a /etc/lightdm/lightdm.conf
        echo "user-session=wayfire" | sudo tee -a /etc/lightdm/lightdm.conf
    fi
else
    echo "[Seat:*]" | sudo tee /etc/lightdm/lightdm.conf
    echo "user-session=wayfire" | sudo tee -a /etc/lightdm/lightdm.conf
fi

echo " "
echo "Disabling unnecessary services..."
sudo systemctl disable cups samba

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

echo "Reboot required to apply changes. Reboot now? (y/n)"
read -r reboot_choice
if [ "$reboot_choice" = "y" ] || [ "$reboot_choice" = "Y" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Reboot skipped. Please reboot manually to apply changes."
fi
