#!/bin/bash

# secure-ssh.sh
# author aidan S
# creates a new ssh user using $1 parameter
# adds a public key from he local repo or curles from the remote repo
# removes roots ability to ssh in

sudo useradd -m -d /home/${1} -s /bin/bash ${1}
sudo mkdir /home/${1}/.ssh
cd /home/aidan/private-tech-journal
sudo cp SYS265/linux/public-keys/id_rsa.pub /home/${1}/.ssh/authorized_keys
sudo chmod 700 /home/${1}/.ssh
sudo chmod 600 /home/${1}/.ssh/authorized_keys
sudo chown -R ${1}:${1} /home/${1}/.ssh

# block the root ssh login

if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
	sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
else
	echo "permit root login not found in /etc/ssh/sshd_config"
fi


sudo systemctl restart sshd.service
