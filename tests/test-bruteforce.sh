#!/bin/bash
# test-bruteforce.sh -- Clinique Sainte-Claire
# Simule 6 tentatives de connexion SSH echouees
# et verifie que Wazuh genere l'alerte attendue.
# Usage : ./test-bruteforce.sh <IP_cible>

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage : $0 <IP_cible>"
    exit 1
fi

echo "[*] Demarrage du test bruteforce SSH vers $TARGET"

for i in $(seq 1 6); do
    ssh -o ConnectTimeout=3 \
        -o StrictHostKeyChecking=no \
        -o BatchMode=yes \
        utilisateur_invalide@"$TARGET" 2>/dev/null || true
    echo "  Tentative $i/6 envoyee"
    sleep 12
done

echo "[*] Attente de 30 secondes pour la remontee d'alerte Wazuh..."
sleep 30

ALERTE=$(grep "Bruteforce AD" \
    /var/ossec/logs/alerts/alerts.log 2>/dev/null | tail -1)

if [ -n "$ALERTE" ]; then
    echo "[OK] Alerte detectee : $ALERTE"
else
    echo "[ECHEC] Aucune alerte generee -- verifier les regles Wazuh"
    exit 1
fi
