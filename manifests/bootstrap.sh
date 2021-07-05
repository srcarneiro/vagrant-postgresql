#!/bin/bash
apt-get update && apt-get -y install puppet && puppet module install puppetlabs-apache
echo "Puppet installado!"

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl stop sshd && systemctl start sshd
echo "SSH com senha habilitado!"