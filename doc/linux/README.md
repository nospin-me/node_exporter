# Prometheus Node Exporter - Linux
----

## default enablovane kolektory
arp, bcache, bonding, btrfs, boottime, conntrack, cpu, cpufreq, diskstats, dmi, edac, entropy, exec, fibrechannel, filefd, filesystem, hwmon, infiniband, ipvs, loadavg, mdadm, meminfo, netclass, netdev, netisr, netstat, nfs, nfsd, nvme, os, powersupplyclass, pressure, rapl, schedstat, selinux, sockstat, softnet, stat, tapestats, textfile, thermal, thermal_zone, time, timex, udp_queues, uname, vmstat, watchdog, xfs, zfs

instalator disabluje default a povoli bezat vybrane:
- CPU
- RAM
- FILESYSTEM (redukovany o: sysfs, proc, tmpfs, devdmpfs, devpts)
- NETDEV
- UNAME
---

### 1) Bud root
```sh
sudo -i
```
alebo
```sh
su -
```

#### 2) Download

instalacka [script/linux/linux-install-sevice.sh](https://raw.githubusercontent.com/nospin-me/node_exporter/refs/heads/main/script/linux/linux-install-sevice.sh)
```sh
wget https://raw.githubusercontent.com/nospin-me/node_exporter/refs/heads/main/script/linux/linux-install-sevice.sh
```
alebo 
```sh
curl -O https://raw.githubusercontent.com/nospin-me/node_exporter/refs/heads/main/script/linux-install-sevice.sh
```

### 3) Install
```sh
chmod 755 linux-install-service.sh
./linux-install-service.sh
```

##### instalacka
- stiahne binarku a rozbali ju do **/opt/node_exporter/**
- vytori systemd.service **/etc/systemd/system/node_exporter.service**
- spusti sluzbu

### 4) Firewall
- firewalld:
```sh
firewall-cmd --add-port=9100/tcp --permanent
firewall-cmd --reload
```
- ufw
```sh
ufw allow 9100/tcp
```
- iptables
```sh
iptables -A INPUT -p tcp --dport 9100 -j ACCEPT
```
---

### Integracia s Prometheus
na Prometheus Serveri do configu **prometheus.yml** pridaj v sekcii **targers:** host:port
```sh
scrape_configs:
  - job_name: "linux-nodes"
    static_configs:
      - targets:
          - "linux-server-1:9100"
          - "linux-server-2:9100"
```
---



