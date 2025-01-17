#!/usr/bin/env bash
echo -ne "
-------------------------------------------------------------------------
                Crummy Automated Arch Linux Installer
                        SCRIPTHOME: CrummyArch
-------------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
sleep 3
source /root/CrummyArch/setup.conf

# Generate the fstab
genfstab -U / >> /etc/fstab

if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi

# echo -e "Installing CyberRe Grub theme..."
# THEME_DIR="/boot/grub/themes"
# THEME_NAME=CyberRe
# echo -e "Creating the theme directory..."
# mkdir -p "${THEME_DIR}/${THEME_NAME}"
# echo -e "Copying the theme..."
# cd ${HOME}/CrummyArch
# cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}
# echo -e "Backing up Grub config..."
# cp -an /etc/default/grub /etc/default/grub.bak
# echo -e "Setting the theme as the default..."
# grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
# echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub

echo -e "Updating grub..."
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "Boot loader is all set!"

echo -ne "
-------------------------------------------------------------------------
                    Enabling Login Display Manager
-------------------------------------------------------------------------
"
sleep 3
systemctl enable gdm.service
# echo -ne "
# -------------------------------------------------------------------------
#                     Setting up SDDM Theme
# -------------------------------------------------------------------------
# "
# sleep 3
# touch /etc/sddm.conf.d/kde_settings.conf
# cat << EOF > /etc/sddm.conf.d/kde_settings.conf
# [Theme]
# Current=breeze
# EOF

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
sleep 3
systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl stop dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth
systemctl enable sshd

echo -ne "
-------------------------------------------------------------------------
                    Enabling SSH with password login
-------------------------------------------------------------------------
"
sleep 3
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo -ne "
-------------------------------------------------------------------------
                    Cleaning 
-------------------------------------------------------------------------
"
sleep 3
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

rm -r /root/CrummyArch
rm -r /home/$USERNAME/CrummyArch

# Replace in the same state
cd $pwd
