# correctifs-windows.ps1 -- Clinique Sainte-Claire
# Applique les correctifs identifies lors du scan OpenVAS
# A executer en tant qu'administrateur de domaine

# VUL-001 : Mises a jour de securite manquantes
Write-Host "[VUL-001] Installation des mises a jour de securite..."
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
Get-WindowsUpdate -Category "Security Updates" -Install -AutoReboot

# VUL-003 : Desactivation des comptes inactifs depuis plus de 6 mois
Write-Host "[VUL-003] Recherche des comptes inactifs..."
$limite = (Get-Date).AddDays(-180)

$comptes = Get-ADUser `
    -Filter {LastLogonDate -lt $limite -and Enabled -eq $true} `
    -Properties LastLogonDate, DisplayName, Department

$comptes | ForEach-Object {
    Disable-ADAccount -Identity $_.SamAccountName
    Write-Host "Desactive : $($_.DisplayName) - $($_.Department)"
}

Write-Host "$($comptes.Count) compte(s) desactive(s)."

$comptes | Select-Object DisplayName, SamAccountName, LastLogonDate, Department |
    Export-Csv "C:\Audit\comptes_desactives_$(Get-Date -Format yyyyMMdd).csv" `
    -Encoding UTF8

# VUL-005 : Verification deploiement Windows Defender
Write-Host "[VUL-005] Verification de l'etat de Windows Defender..."
Get-ADComputer -Filter * | ForEach-Object {
    try {
        $s = Invoke-Command -ComputerName $_.Name -ScriptBlock {
            Get-MpComputerStatus |
                Select-Object RealTimeProtectionEnabled
        } -ErrorAction Stop
        if (-not $s.RealTimeProtectionEnabled) {
            Write-Host "[ATTENTION] Defender inactif sur : $($_.Name)"
        }
    } catch {
        Write-Host "[ERREUR] Poste injoignable : $($_.Name)"
    }
}

Write-Host "Correctifs termines."
