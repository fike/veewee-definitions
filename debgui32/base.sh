# Update the box
gpg --check-sigs --fingerprint \
	--keyring /etc/apt/trusted.gpg.d/pkg-mozilla-archive-keyring.gpg \
	--keyring /usr/share/keyrings/debian-keyring.gpg pkg-mozilla-maintainers
echo "deb http://mozilla.debian.net/ wheezy-backports iceweasel-release" \
	>> /etc/apt/sources.list.d/iceweasel.list
apt-get -y update
apt-get -y install pkg-mozilla-archive-keyring
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev
apt-get -y install curl unzip
apt-get -y --force-yes install -t wheezy-backports iceweasel
apt-get clean
apt-get autoremove

# Set up sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=pt_BR"
EOF

update-grub
