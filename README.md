# Prometheus node exporter

_pre **windows & linux**_

cielom je obmedzit zasielanie balastu do TSBD

---
enablovane kolektory:
- cpu
- meminfo
- filesystem (bez pseudoFS)
- netdev
- uname
---
-> zatial bez otovrenia portov na lokal firewalle (poznamka pre mna aby som nezabudol)

---
### postup pre linux

stiahni -> [linux-install-service.sh](https://github.com/nospin-me/node_exporter/blob/main/script/linux-install-sevice.sh)

- root -ni sa 
- chmod 755 linux-install-service.sh
- spusti ./linux-install-service.sh
- overenie 
```curl -s http://localhost:9100/metrics > /dev/null && echo "OK"   || echo "FAIL" ```

ak to nepojde over firewall ;-)

---

zatial tolko ...

