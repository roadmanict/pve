#/bin/bash
set -e
apt update
apt full-upgrade --yes
apt install sudo unattended-upgrades apt-listchanges --yes

# Configure unattended updates
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

# Create new user
useradd -s /bin/bash -m lxc || echo "User already exists"

usermod -a -G sudo lxc

mkdir /home/lxc/.ssh || echo "Directory exists"
rm -f /home/lxc/.ssh/authorized_keys
touch /home/lxc/.ssh/authorized_keys

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUiy7L19SOYzjvapxIPjORif1Fa3/tjpVqGRVf5D4k4HpVgVaQS/Rdm8XJaC4cmxR7ulvxOR47Ozlt+PmMiZ9vd0ZJFXRr3xGpVP9mzK9hbDDXRqFIzgg2b5CsbbHA3TPOx3v3diZL6THRWMkV+BzIIQKh9/UFsGI92iUzFckWGaA5O7Ez61UAiwAdLF4J99nMRKuAcOljx3onXsGNJtw68fElfODBLaAu4zeAVpvH6pUvP7oT8NET95vC18m5ipetaGiRcWQYrnJO5ki6ZLNtldGPsZ9z4gXJBhNyCdkyzF+MLyMsRbSMQS21PHxcVM24yb38wcT4P6FrTymnpcqX geert@oc3413724060.ibm.com" >> /home/lxc/.ssh/authorized_keys

chmod 700 /home/lxc/.ssh
chmod 600 /home/lxc/.ssh/authorized_keys

chown -R lxc:lxc /home/lxc/.ssh