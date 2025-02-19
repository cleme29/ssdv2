#!/bin/bash
###############################################################
# SSD : prerequis.sh                                          #
# Installe les prérequis avant l'installation d'une seedbox   #
# Si un fichier de configuration existe déjà                  #
# il ne sera pas touché                                       #
###############################################################

if [ "$USER" != "root" ]; then
  echo "Ce script doit être lancé par root ou en sudo"
  exit 1
fi

## Constants
readonly PIP="9.0.3"
readonly ANSIBLE="2.9"

## Environmental Variables
export DEBIAN_FRONTEND=noninteractive

## Install Pre-Dependencies
apt-get update
apt-get install -y --reinstall \
  software-properties-common \
  apt-transport-https \
  lsb-release \
  sudo
## Add apt repos
osname=$(lsb_release -si)

if echo "$osname" "Debian" &>/dev/null; then
  {
    add-apt-repository main
    add-apt-repository non-free
    add-apt-repository contrib
  } >>/dev/null 2>&1
elif echo "$osname" "Ubuntu" &>/dev/null; then
  {
    add-apt-repository main
    add-apt-repository universe
    add-apt-repository restricted
    add-apt-repository multiverse
  } >>/dev/null 2>&1

fi
apt-get update

## Install apt Dependencies
apt-get install -y --reinstall \
  nano \
  build-essential \
  libssl-dev \
  libffi-dev \
  python3-dev \
  python3-pip \
  python-dev \
  python3-venv \
  sqlite3 \
  apache2-utils \
  dnsutils \
  python3-apt-dbg \
  python3-apt \
  python-apt-doc \
  python-apt-common \
  ca-certificates \
    curl \
    gnupg \
    lsb-release \
    fuse3 \
    apparmor

rm -f /usr/bin/python

ln -s /usr/bin/python3 /usr/bin/python

cat <<EOF >/etc/logrotate.d/ansible
${SETTINGS_SOURCE}/logs/*.log {
  rotate 7
  daily
  compress
  missingok
}
EOF

if [ ! -f /etc/sudoers.d/${1} ]; then
  echo "${1} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${1}
fi
