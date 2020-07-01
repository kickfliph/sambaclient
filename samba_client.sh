#!/bin/bash

echo "10.0.2.15     cliente01.samba.example.com     cliente01" >> /etc/hosts
cp /etc/resolv.conf /etc/resolv.conf.ORG
cp resolv.conf /etc/resolv.conf
systemctl restart networking

nslookup www.google.com 

# detect os
# $os_version variables aren't always in use, but are kept here for convenience
if grep -qs "ubuntu" /etc/os-release; then
	os="ubuntu"
	os_version=$(grep 'version_id' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
        apt-get update
        apt-get upgrade -y
        apt -y install winbind libpam-winbind libnss-winbind krb5-config samba-dsdb-modules samba-vfs-modules
elif [[ -e /etc/debian_version ]]; then
	os="debian"
	os_version=$(grep -oe '[0-9]+' /etc/debian_version | head -1)
        apt-get update
        apt-get upgrade -y
        apt -y install winbind libpam-winbind libnss-winbind krb5-config samba-dsdb-modules samba-vfs-modules
elif [[ -e /etc/centos-release ]]; then
	os="centos"
	os_version=$(grep -oe '[0-9]+' /etc/centos-release | head -1)
    yum install gcc gcc-c++ kernel-devel make wget git perl-Digest-SHA.x86_64 -y
    cd /root
    yum install samba
elif [[ -e /etc/fedora-release ]]; then
	os="fedora"
	os_version=$(grep -oE '[0-9]+' /etc/fedora-release | head -1)
    yum install gcc gcc-c++ kernel-devel make wget git perl-Digest-SHA.x86_64 -y
    cd /root
    yum install samba
else
	echo "This installer seems to be running on an unsupported distribution.
Supported distributions are Ubuntu, Debian, CentOS, and Fedora."
	exit
fi



