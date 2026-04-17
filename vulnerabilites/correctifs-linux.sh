#!/bin/bash
# correctifs-linux.sh -- Clinique Sainte-Claire
# Applique les correctifs sur les serveurs Linux
# A executer en root ou avec sudo

set -e

# VUL-002 : Mise a jour OpenVPN
echo "[VUL-002] Mise a jour OpenVPN..."
apt update -q
apt install -y openvpn
systemctl restart openvpn@server
VERSION=$(openvpn --version | head -1)
echo "OpenVPN mis a jour : $VERSION"

# VUL-003 : Blocage acces NAS depuis VLAN visiteurs
echo "[VUL-003] Verification regle pfSense NAS..."
echo "Regle a appliquer manuellement dans pfSense :"
echo "  Action      : Bloquer"
echo "  Interface   : VLAN50_Visiteurs"
echo "  Source      : 10.50.0.0/24"
echo "  Destination : 10.30.0.15 (NAS Synology)"
echo "  Protocole   : Tous"

# VUL-006 : Mise a jour protocole Wi-Fi
echo "[VUL-006] Migration WPA2-TKIP vers WPA2-AES..."
echo "A effectuer dans l'interface UniFi Controller :"
echo "  SSID : SC-Medecins"
echo "  Securite : WPA2-AES (remplacer WPA2-TKIP)"

# Verification Nginx
echo "[NGINX] Verification de la configuration TLS..."
nginx -t && systemctl reload nginx
echo "Nginx rechargé."

echo "Correctifs Linux termines."
