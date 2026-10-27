#!/bin/bash

clear

line() {
echo "====================================================================="
}

pause_lab() {
echo
read -p "Press Enter to continue..."
clear
}

show_command() {
echo
echo "COMMAND TO BE EXECUTED:"
echo "-------------------------------------------------------------"
echo "$1"
echo "-------------------------------------------------------------"
echo
}

line
echo "SALTSTACK HANDS-ON LEARNING LAB"
line

echo
echo "Goal:"
echo "Build a Salt Master and Salt Minion"
echo "while learning every command."
echo

pause_lab

#################################################################

line
echo "STEP 1 - UPDATE PACKAGE INDEX"
line

echo
echo "WHAT?"
echo "Refresh package information."

echo
echo "WHY?"
echo "Ubuntu tracks software through repositories."
echo "Before installing software, refresh package metadata."

show_command "apt update"

echo "COMMAND BREAKDOWN"
echo "apt     -> Ubuntu package manager"
echo "update  -> Refresh package information"

read -p "Run this command? Press Enter..."

apt update

echo
echo "Expected:"
echo "- No errors"
echo "- Package list refreshed"

pause_lab

#################################################################

line
echo "STEP 2 - INSTALL REQUIRED TOOLS"
line

echo
echo "WHAT?"
echo "Install Curl and GPG"

echo
echo "WHY?"
echo "curl downloads files"
echo "gpg validates repository keys"

show_command "apt install -y curl gpg"

echo "COMMAND BREAKDOWN"
echo "install -> install package"
echo "-y      -> automatically answer yes"

read -p "Run this command? Press Enter..."

apt install -y curl gpg

pause_lab

#################################################################

line
echo "STEP 3 - CREATE KEYRING DIRECTORY"
line

echo
echo "WHAT?"
echo "Create secure key storage location"

show_command "mkdir -p /etc/apt/keyrings"

echo "BREAKDOWN"
echo "mkdir -> create directory"
echo "-p    -> create parent directories if needed"

read -p "Run this command? Press Enter..."

mkdir -p /etc/apt/keyrings

ls -ld /etc/apt/keyrings

pause_lab

#################################################################

line
echo "STEP 4 - ADD SALT REPOSITORY GPG KEY"
line

echo
echo "WHY?"
echo "Ubuntu must trust packages before installing them."

show_command "curl ... | gpg --dearmor | tee ..."

echo
echo "REAL WORLD:"
echo "All enterprise software repositories use signing keys."

read -p "Run this command? Press Enter..."

curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public \
| gpg --dearmor \
| tee /etc/apt/keyrings/salt-archive-keyring.pgp >/dev/null

echo
echo "Salt GPG Key Added"

pause_lab

#################################################################

line
echo "STEP 5 - ADD SALT REPOSITORY"
line

echo
echo "WHAT?"
echo "Tell Ubuntu where to download Salt packages."

show_command "curl ... salt.sources"

read -p "Run this command? Press Enter..."

curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources \
| tee /etc/apt/sources.list.d/salt.sources >/dev/null

echo
echo "Repository Added"

pause_lab

#################################################################

line
echo "STEP 6 - REFRESH REPOSITORIES"
line

echo
echo "WHY?"
echo "Ubuntu needs to read the newly added Salt repository."

show_command "apt update"

read -p "Run this command? Press Enter..."

apt update

pause_lab

#################################################################

line
echo "STEP 7 - VERIFY SALT PACKAGE"
line

show_command "apt policy salt-master"

echo "Purpose:"
echo "Check available Salt versions"

read -p "Run this command? Press Enter..."

apt policy salt-master

pause_lab

#################################################################

line
echo "STEP 8 - INSTALL SALT MASTER"
line

echo
echo "CONCEPT:"
echo "Salt Master = Brain"
echo "Sends commands to managed systems"

show_command "apt install -y salt-master"

read -p "Run this command? Press Enter..."

apt install -y salt-master

pause_lab

#################################################################

line
echo "STEP 9 - VERIFY MASTER"
line

show_command "salt-master --version"

read -p "Run this command? Press Enter..."

salt-master --version

pause_lab

#################################################################

line
echo "STEP 10 - CHECK MASTER SERVICE"
line

show_command "systemctl status salt-master --no-pager"

echo
echo "Look For:"
echo "Active: active (running)"

read -p "Run this command? Press Enter..."

systemctl status salt-master --no-pager

pause_lab

#################################################################

line
echo "STEP 11 - INSTALL SALT MINION"
line

echo
echo "CONCEPT:"
echo "Minion = Managed Machine"

show_command "apt install -y salt-minion"

read -p "Run this command? Press Enter..."

apt install -y salt-minion

pause_lab

#################################################################

line
echo "STEP 12 - CONFIGURE MINION ID"
line

show_command "echo 'ubuntu-minion-01' > /etc/salt/minion_id"

echo
echo "WHY?"
echo "Every minion needs a unique identity."

read -p "Run this command? Press Enter..."

echo "ubuntu-minion-01" > /etc/salt/minion_id

cat /etc/salt/minion_id

pause_lab

#################################################################

line
echo "STEP 13 - CONFIGURE MASTER ADDRESS"
line

show_command "echo 'master: 127.0.0.1' > /etc/salt/minion.d/master.conf"

echo
echo "WHY?"
echo "The minion must know where the master exists."

read -p "Run this command? Press Enter..."

mkdir -p /etc/salt/minion.d

echo "master: 127.0.0.1" > /etc/salt/minion.d/master.conf

cat /etc/salt/minion.d/master.conf

pause_lab

#################################################################

line
echo "STEP 14 - START SERVICES"
line

show_command "systemctl enable --now salt-master"
show_command "systemctl enable --now salt-minion"

echo
echo "WHY?"
echo "Start services now and after reboot."

read -p "Run this command? Press Enter..."

systemctl enable --now salt-master
systemctl enable --now salt-minion

systemctl restart salt-master
systemctl restart salt-minion

pause_lab

#################################################################

line
echo "STEP 15 - WAIT FOR REGISTRATION"
line

echo
echo "Minion needs time to contact Master."

show_command "sleep 15"

sleep 15

pause_lab

#################################################################

line
echo "STEP 16 - LIST KEYS"
line

show_command "salt-key -L"

echo
echo "LOOK FOR"
echo "Unaccepted Keys"
echo "Accepted Keys"

read -p "Run this command? Press Enter..."

salt-key -L

pause_lab

#################################################################

line
echo "STEP 17 - ACCEPT KEYS"
line

show_command "salt-key -A -y"

echo
echo "WHY?"
echo "Master must trust Minion."

read -p "Run this command? Press Enter..."

salt-key -A -y

pause_lab

#################################################################

line
echo "STEP 18 - VERIFY ACCEPTED KEYS"
line

show_command "salt-key -L"

read -p "Run this command? Press Enter..."

salt-key -L

pause_lab

#################################################################

line
echo "STEP 19 - TEST COMMUNICATION"
line

show_command "salt '*' test.ping"

echo
echo "BREAKDOWN"
echo "salt      -> Salt execution engine"
echo "'*'       -> All minions"
echo "test.ping -> Connectivity test"

read -p "Run this command? Press Enter..."

salt '*' test.ping

pause_lab

#################################################################

line
echo "STEP 20 - RUN REMOTE COMMAND"
line

show_command "salt '*' cmd.run 'hostname'"

echo
echo "WHY?"
echo "Execute Linux commands remotely."

read -p "Run this command? Press Enter..."

salt '*' cmd.run 'hostname'

pause_lab

#################################################################

line
echo "STEP 21 - CHECK UPTIME"
line

show_command "salt '*' cmd.run 'uptime'"

read -p "Run this command? Press Enter..."

salt '*' cmd.run 'uptime'

pause_lab

#################################################################

line
echo "STEP 22 - CHECK MEMORY"
line

show_command "salt '*' cmd.run 'free -h'"

read -p "Run this command? Press Enter..."

salt '*' cmd.run 'free -h'

pause_lab

#################################################################

line
echo "STEP 23 - VIEW GRAINS"
line

show_command "salt '*' grains.item os"

echo
echo "WHAT ARE GRAINS?"
echo "Facts about a system."

read -p "Run this command? Press Enter..."

salt '*' grains.item os

pause_lab

#################################################################

line
echo "STEP 24 - VIEW OS VERSION"
line

show_command "salt '*' grains.item osrelease"

read -p "Run this command? Press Enter..."

salt '*' grains.item osrelease

pause_lab

#################################################################

line
echo "STEP 25 - VIEW SYSTEM DETAILS"
line

show_command "salt '*' grains.item os kernel cpuarch"

read -p "Run this command? Press Enter..."

salt '*' grains.item os kernel cpuarch

pause_lab

#################################################################

line
echo "LAB COMPLETE"
line

echo
echo "YOU LEARNED:"
echo
echo "✓ apt update"
echo "✓ repositories"
echo "✓ gpg keys"
echo "✓ salt master"
echo "✓ salt minion"
echo "✓ minion id"
echo "✓ key acceptance"
echo "✓ test.ping"
echo "✓ remote command execution"
echo "✓ grains"
echo
echo "Congratulations!"
echo "You completed the SaltStack Fundamentals Lab."
