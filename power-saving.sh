#!/bin/zsh

set -xe

file_cpio="/etc/mkinitcpio.conf"
file_grub="/etc/default/grub"
# file_cpio="$HOME/mkinitcpio.conf"
# file_grub="$HOME/grub"

sed -i 's/^MODULES=""/MODULES=(i915)/' \
    ${file_cpio}

grub_flags=(
    acpi_osi=Linux acpi=force acpi_enforce_resources=lax
    radeon\\.dpm=1 radeon\\.audio=1
    i915\\.modeset=1
    rd\\.udev\\.log-priority=3
    ath9k\\.ps_enable=1
)
echo ${grub_flags}
sed -i "s/^GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"${grub_flags}\"/" \
    ${file_grub}

install(){
    pacman -S $* --noconfirm --needed
}
install intel-ucode
install xf86-video-fbdev
install tlp tlp-rdw iw smartmontools ethtool x86_energy_perf_policy
install lm_sensors thermald

mkinitcpio -P
systemctl mask systemd-rfkill.socket systemd-rfkill.service
sensors-detect --auto
systemctl enable thermald && systemctl start thermald
update-grub
