#!/usr/bin/env python3
# surveillance.py -- Clinique Sainte-Claire
# Vérifie toutes les heures les services critiques,
# l'espace disque et la présence des sauvegardes du jour.

import subprocess, smtplib, ssl, shutil, os
from datetime import datetime, date
from email.mime.text import MIMEText

SMTP_HOST  = "smtp.sainte-claire.fr"
SMTP_PORT  = 587
SMTP_USER  = "monitoring@sainte-claire.fr"
SMTP_PASS  = "***"
DEST_EMAIL = "it@sainte-claire.fr"

DISK_THRESHOLD = 80
BACKUP_PATH    = "\\\\nas-backup\\sauvegardes"
SERVICES       = ["Mediboard", "MSSQLSERVER", "ADWS", "OpenVPNService"]

def check_disk():
    alerts = []
    total, used, _ = shutil.disk_usage("C:\\")
    pct = (used / total) * 100
    if pct >= DISK_THRESHOLD:
        alerts.append(f"[DISQUE] C:\\ a {pct:.1f}%")
    return alerts

def check_services():
    alerts = []
    for svc in SERVICES:
        r = subprocess.run(["sc", "query", svc],
                           capture_output=True, text=True)
        if "RUNNING" not in r.stdout:
            alerts.append(f"[SERVICE] {svc} ne repond plus")
    return alerts

def check_backup():
    today = date.today()
    try:
        files = os.listdir(BACKUP_PATH)
        ok = any(datetime.fromtimestamp(
            os.path.getmtime(os.path.join(BACKUP_PATH, f))
            ).date() == today for f in files)
        if not ok:
            return ["[BACKUP] Aucune sauvegarde detectee aujourd'hui"]
    except Exception as e:
        return [f"[BACKUP] Acces impossible : {e}"]
    return []

def send_alert(messages):
    body = "\n".join(messages)
    body += f"\n\n--\nRapport du {datetime.now().strftime('%d/%m/%Y a %H:%M')}"
    msg = MIMEText(body, "plain", "utf-8")
    msg["Subject"] = f"[Sainte-Claire] {len(messages)} alerte(s)"
    msg["From"] = SMTP_USER
    msg["To"]   = DEST_EMAIL
    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as s:
        s.starttls(context=ssl.create_default_context())
        s.login(SMTP_USER, SMTP_PASS)
        s.sendmail(SMTP_USER, DEST_EMAIL, msg.as_string())

def main():
    alertes = check_disk() + check_services() + check_backup()
    if alertes:
        send_alert(alertes)
        print(f"{len(alertes)} alerte(s) envoyee(s).")
    else:
        print("Aucune anomalie detectee.")

if __name__ == "__main__":
    main()
