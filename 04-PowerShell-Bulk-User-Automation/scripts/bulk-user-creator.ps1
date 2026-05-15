# =============================================================================
# Bulk User Creator for Active Directory
# =============================================================================
# Author:   Iris
# Project:  Active Directory Home Lab
# Domain:   local.laboratory
# Purpose:  Read users from a CSV file and create them in AD, with each user
#           placed inside an Organisational Unit named after their department.
#           OUs are created automatically if they do not already exist.
#
# Usage:
#   1. Place users.csv in C:\ on the Domain Controller
#   2. Open PowerShell ISE as Administrator
#   3. Run this script
#
# CSV format (header row required):
#   firstname,lastname,username,department
#   Sarah,Smith,ssmith,IT
#
# Notes:
#   - Default password is set to a complex string at the top of the script
#   - Default Domain Policy must allow the chosen password complexity
#     (see section 05 of this lab for the GPO change required)
#   - Try/catch blocks make the script keep running if one user fails
# =============================================================================

# --- Configuration ----------------------------------------------------------

$CsvPath      = "C:\users.csv"
$DomainPath   = "DC=local,DC=laboratory"
$UpnSuffix    = "local.laboratory"
$Password     = "root11root!!"

# --- Pre-flight checks ------------------------------------------------------

if (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR: CSV file not found at $CsvPath" -ForegroundColor Red
    exit 1
}

$users = Import-Csv $CsvPath
Write-Host "Loaded $($users.Count) users from CSV" -ForegroundColor White

# --- Step 1: Create all OUs first -----------------------------------------
# Doing OU creation as a separate pass avoids a race condition where the
# script tries to create the same OU twice for users in the same department.

$departments = $users.department | Select-Object -Unique
foreach ($dept in $departments) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$dept'")) {
        New-ADOrganizationalUnit -Name $dept -Path $DomainPath
        Write-Host "OU Created: $dept" -ForegroundColor Cyan
    } else {
        Write-Host "OU already exists, skipping: $dept" -ForegroundColor DarkGray
    }
}

# Give AD a moment to register the new OUs
Start-Sleep -Seconds 2

# --- Step 2: Create the users ----------------------------------------------

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

foreach ($user in $users) {
    $ouPath = "OU=$($user.department),$DomainPath"
    $upn    = "$($user.username)@$UpnSuffix"
    $name   = "$($user.firstname) $($user.lastname)"

    try {
        New-ADUser -Name $name `
                   -GivenName       $user.firstname `
                   -Surname         $user.lastname `
                   -SamAccountName  $user.username `
                   -UserPrincipalName $upn `
                   -Path            $ouPath `
                   -AccountPassword $securePassword `
                   -Enabled         $true

        Write-Host "User Created: $($user.username) -> $($user.department)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed: $($user.username) - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "`nBulk import complete." -ForegroundColor White
