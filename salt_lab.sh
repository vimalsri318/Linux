#!/bin/bash

echo "=== Updating Packages ==="
apt update

echo "=== Installing Dependencies ==="
apt install -y curl gpg

echo "=== Adding Salt Repository ==="
mkdir -p /etc/apt/keyrings

curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public \
| gpg --dearmor \
| tee /etc/apt/keyrings/salt-archive-keyring.pgp > /dev/null

curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources \
| tee /etc/apt/sources.list.d/salt.sources > /dev/null

echo "=== Refreshing Package List ==="
apt update

echo "=== Installing Salt Master ==="
apt install -y salt-master

echo "=== Installing Salt Minion ==="
apt install -y salt-minion

echo "=== Configuring Minion ==="

echo "ubuntu-minion-01" > /etc/salt/minion_id

mkdir -p /etc/salt/minion.d

cat > /etc/salt/minion.d/master.conf << EOF
master: 127.0.0.1
EOF

echo "=== Starting Services ==="

systemctl enable --now salt-master
systemctl enable --now salt-minion

systemctl restart salt-master
systemctl restart salt-minion

echo ""
echo "=================================="
echo "Salt installation completed"
echo "=================================="
echo ""
echo "Next command to run:"
echo "salt-key -L"
echo ""
echo "Then accept key:"
echo "salt-key -A"
echo ""
echo "Test:"
echo "salt '*' test.ping"
``
