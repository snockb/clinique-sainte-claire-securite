# Cahier de recettes — Clinique Sainte-Claire

Date d'exécution : semaine 15
Exécuté par : technicien IT (n'ayant pas réalisé les déploiements)
Validé par : référent sécurité

---

## Réseau

| ID    | Test                          | Résultat | Observation          |
|-------|-------------------------------|----------|----------------------|
| T-001 | Isolation VLAN visiteurs      | OK       |                      |
| T-002 | Accès VPN avec MFA            | OK       |                      |
| T-003 | TLS 1.3 actif sur Mediboard   | OK       |                      |
| T-004 | Redirection HTTP vers HTTPS   | OK       |                      |
| T-005 | Accès BDD depuis VLAN 10      | OK       | Connexion refusée    |

## Accès

| ID    | Test                          | Résultat | Observation          |
|-------|-------------------------------|----------|----------------------|
| T-006 | Compte générique supprimé     | OK       | poste-accueil inexistant |
| T-007 | Accès Mediboard compte RH     | OK       | Accès refusé         |
| T-008 | Verrouillage auto après 5 min | OK       |                      |

## Surveillance

| ID    | Test                          | Résultat | Observation               |
|-------|-------------------------------|----------|---------------------------|
| T-009 | Alerte bruteforce AD          | OK       | Alerte en 1 min 40        |
| T-010 | Alerte connexion hors horaires| OK       |                           |
| T-011 | Alerte sauvegarde manquante   | OK       | Email reçu à 07h03        |
| T-012 | Alerte accès Mediboard non méd| OK       | Alerte niveau 14 générée  |

---

Signature référent sécurité : _______________  Date : ___/___/______
