#!/bin/bash
################################################################################
# Script for installing creating SSH
################################################################################
OE_USER="odoo"
OE_HOME="/$OE_USER"
OE_HOME_EXT="/$OE_USER/${OE_USER}-server"

GIT_USER=$1
GIT_PUDNAME=$2
GIT_PASSPHASE=$3
GIT_FILELOCATION=$4
GIT_checkout=$5

echo -e "\n---- Create ODOO system user ----"
sudo adduser --system --quiet --shell=/bin/bash --home=$OE_HOME --gecos 'ODOO' --group $OE_USER
#The user should also be added to the sudo'ers group.
sudo adduser $OE_USER sudo

echo -e "\n---- Create Log directory ----"
sudo mkdir /var/log/$OE_USER
sudo chown $OE_USER:$OE_USER /var/log/$OE_USER


#--------------------------------------------------
# Configuring GIT
#--------------------------------------------------
echo -e "\n---- Create SSH credentials for Github ----"
sudo mkdir $OE_HOME/.ssh
sudo cd $OE_HOME/.ssh
read -p "Enter Git username: " OE_email
ssh-keygen -t rsa -b 4096 -C "$OE_email"  -p "$GIT_PASSPHASE" -f "$GIT_PUDNAME"
echo -e "\n-- Copy SSH credentials to Github --"
cat $OE_HOME/.ssh/odoo.pub
read -p "Copy and Press enter to continue to downloading"

sudo git config --global user.email "$GIT_USER"
sudo git config --global user.name "$GIT_PUDNAME"





#--------------------------------------------------
# Install ODOO
#--------------------------------------------------
echo -e "\n==== Installing ODOO Server ===="
#sudo git clone --depth 1 --branch $OE_VERSION https://www.github.com/odoo/odoo $OE_HOME_EXT/
git clone -c "core.sshCommand=ssh -i ~/.ssh/$GIT_PUDNAME -F /dev/null" git@github.com:$GIT_FILELOCATION

#sudo git fetch --all 
#sudo git checkout remotes/origin/$GIT_checkout
