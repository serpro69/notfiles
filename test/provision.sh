#!/usr/bin/env bash

sudo apt-get update
sudo apt-get dist-upgrade

sudo apt-get install -y curl git vim zsh

# password-less sudo
sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g'
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Customized the sudoers file for passwordless access to the vagrant user!"
echo "vagrant user:";  su - vagrant -c id
