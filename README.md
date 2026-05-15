# Active Directory Home Lab

A Windows Server 2022 Active Directory environment built from scratch in VirtualBox. The project covers domain controller promotion, user and OU management, PowerShell automation for bulk onboarding, Group Policy configuration, and NTFS file share security following the Principle of Least Privilege.

Built by Iris as part of a pre-employability IT programme, targeted at junior IT support and apprenticeship roles.

---

## What this project demonstrates

- Building and configuring a Windows Server 2022 virtual machine
- Promoting a server to a Domain Controller and creating a new forest
- Setting up DNS as part of the domain promotion
- Designing an Organisational Unit (OU) structure for a fake company
- Writing PowerShell to onboard a batch of users from a CSV file
- Diagnosing and fixing real errors (server unwilling to process the request, password complexity rejection)
- Editing Group Policy through GPMC to adjust domain-wide security settings
- Configuring NTFS and Share permissions on a file server
- Applying the Principle of Least Privilege (PoLP) so only the right people get access

---

## Environment

| Component | Value |
|-----------|-------|
| Hypervisor | Oracle VirtualBox |
| Server OS | Windows Server 2022 Standard (Desktop Experience) |
| RAM | 12 GB |
| vCPU | 6 cores |
| Disk | 100 GB dynamic |
| Forest | local.laboratory |
| Domain Controller | DC-01 |
| Static IP | 172.16.0.1 |

---

## Project sections

Each folder below contains a README explaining what was done, a difficulties file covering where things went wrong, a lessons file summarising what was learned, and a screenshots folder showing proof of work.

1. Server Setup and Configuration - `01-Server-Setup-and-Configuration/`
2. Active Directory Installation - `02-Active-Directory-Installation/`
3. User Management and Organisation - `03-User-Management-and-Organisation/`
4. PowerShell Bulk User Automation - `04-PowerShell-Bulk-User-Automation/`
5. Group Policy Password Configuration - `05-Group-Policy-Password-Configuration/`
6. NTFS Permissions and Data Security - `06-NTFS-Permissions-and-Data-Security/`

---

## Skills mapped to the role

For a junior IT support technician pathway, this project hits the core domains that hiring managers look for:

- Identity and Access Management - creating users, OUs, and managing accounts in AD
- Scripting and Automation - PowerShell for repetitive admin tasks
- Group Policy - domain-wide configuration changes via GPMC
- File Server Administration - share and NTFS permission layering
- Troubleshooting - reading error messages, isolating the cause, and fixing it
- Documentation - keeping a clear record of changes for handover

---

## Honest note on what did not work

Before this AD lab, I attempted to deploy osTicket on XAMPP locally. That setup hit repeated 500 errors caused by a corrupted MySQL/MariaDB authentication state and a broken `_S()` translation function from a missing gettext extension. After hours of debugging through PowerShell, php.ini edits, and direct database injection, I made the call to pivot to a stronger project that better fits the apprenticeship pathway. Switching to Active Directory was the right move because it maps more directly to the day-to-day skills of a junior support technician. The lesson is logged in `lessons-from-osticket-pivot.md` at the root of this repo.
