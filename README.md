# Projet de sécurisation du SI — Clinique Sainte-Claire

## Contexte

Ce dépôt contient l'ensemble des scripts, configurations et documents
techniques produits dans le cadre du projet de sécurisation du système
d'information de la Clinique Sainte-Claire (Lyon).

L'objectif du projet est de renforcer la sécurité de l'infrastructure
sur quatre axes : architecture réseau, gestion des accès, surveillance,
et sensibilisation du personnel.

- Durée du projet : 16 semaines
- Équipe : 2 techniciens IT internes + référent sécurité
- Référentiels : RGPD, HDS, ANSSI, ISO 27001

---

## Structure du dépôt
clinique-sainte-claire-securite/
│
├── README.md
│
├── architecture/
│   └── regles-pfsense.txt
│
├── surveillance/
│   ├── surveillance.py
│   ├── wazuh-agent-config.xml
│   └── wazuh-rules-custom.xml
│
├── vulnerabilites/
│   ├── correctifs-windows.ps1
│   └── correctifs-linux.sh
│
├── tests/
│   ├── cahier-de-recettes.md
│   └── test-bruteforce.sh
│
└── sensibilisation/
└── plan-sensibilisation.md

---

## Prérequis

- pfSense 2.7+
- Wazuh 4.7+
- Python 3.10+
- PowerShell 5.1+
- OpenVPN 2.6+

---

## Infrastructure simulée

| Composant | Rôle | IP |
|-----------|------|----|
| pfSense | Pare-feu, segmentation VLANs | 192.168.10.1 |
| Debian-DMZ | Nginx, OpenVPN, Fail2ban | 192.168.10.2 |
| Windows Server 2019 | Active Directory, Mediboard | 192.168.30.10 |
| Wazuh SIEM | Centralisation logs, alertes | 192.168.40.10 |

---

## Avertissement

Ce dépôt est à usage pédagogique dans le cadre d'un dossier
d'admission M2 Expert en Cybersécurité. Les configurations
sont adaptées à un environnement de laboratoire virtuel.
