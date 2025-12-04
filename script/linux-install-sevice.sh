#!/bin/bash
#set -euo pipefail

# 
# konst
#
DOWNLOAD_URL="https://github.com/nospin-me/node_exporter/raw/refs/heads/main/install/linux/node_exporter-1.10.2.linux-amd64.tar.gz"
INSTALL_DIR="/opt/node_exporter"
PID="$$"
TEMP_DIR="/tmp/node_exporter_${PID}"
USER="node_exporter"
#GRP="node_exporter"

#
# user check
#
if [ "$(id -u)" -ne 0 ]
then
	echo " ->  root-ni sa"
	exit 1
fi

if ! getent passwd "${USER}" > /dev/null
then
	echo "adduser  ${USER}..."
	useradd --system --no-create-home --shell /usr/sbin/nologin "${USER}"
fi

#
# download extract install ...
#

mkdir -p "${TEMP_DIR}"

echo " -> download $DOWNLOAD_URL"
curl -L "${DOWNLOAD_URL}" -o "${TEMP_DIR}/node_exporter.tar.gz"

mkdir -p "${INSTALL_DIR}"
tar -xzfv "${TEMP_DIR}/node_exporter.tar.gz" -C "${INSTALL_DIR}" --strip-components=1
chown -R root:root "${INSTALL_DIR}"
chmod 755 "${INSTALL_DIR}/node_exporter"

rm -rf "${TEMP_DIR}"

# -----

#
# systemd service
#

echo " -> systemd service "

cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=${USER}
Group=${GRP}
ExecStart=${INSTALL_DIR}/node_exporter \
  --collector.disable-defaults \
  --collector.cpu \
  --collector.meminfo \
  --collector.filesystem \
  --collector.filesystem.ignored-fs-types=sysfs,proc,tmpfs,devtmpfs,devpts \
  --collector.netdev \
  --collector.uname \
  --log.level=info \
  --web.listen-address=0.0.0.0:9100
Restart=always

#NoNewPrivileges=true
#ProtectSystem=strict
#ProtectHome=true
#PrivateTmp=true
#PrivateDevices=true
#ProtectKernelLogs=true
#ProtectKernelModules=true
#ProtectKernelTunables=true
#MemoryDenyWriteExecute=true
#RestrictSUIDSGID=true

[Install]
WantedBy=multi-user.target
EOF

#
# add & start service
#
echo " -> start"
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

echo " -------- "
systemctl status node_exporter --no-pager
echo " -------- "
echo "hotovson ..."

