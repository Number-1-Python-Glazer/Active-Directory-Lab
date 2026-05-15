# LinkedIn Post Drafts

Three versions of a LinkedIn post for this project, ranging from short to long. Pick whichever fits the energy you want.

---

## Version 1: Short and punchy

New project up: a Windows Server 2022 Active Directory home lab, built from scratch.

What is in it:
- Domain Controller promotion with DNS
- PowerShell script that bulk-creates users from a CSV
- Group Policy edits via GPMC
- NTFS file share locked down with the Principle of Least Privilege

Full write-up with screenshots, scripts, and what broke along the way is on my GitHub.

Targeting junior IT support and apprenticeship roles. Always happy to chat about home lab projects or AD troubleshooting.

---

## Version 2: Story format

Two days ago I tried to set up osTicket locally and ran into so many MariaDB authentication errors I lost count. Hours of log diving later, I made the call to pivot to a project that better fits the apprenticeship pathway I am chasing.

Result: a working Windows Server 2022 Active Directory home lab.

What it covers:
- Building the Server 2022 VM in VirtualBox
- Promoting the server to a Domain Controller, creating the local.laboratory forest
- Designing an OU structure with the underscore trick for admin sorting
- Writing a PowerShell script to bulk-import users from a CSV with proper try/catch error handling
- Debugging a race condition where OUs were created faster than AD could replicate them
- Editing the Default Domain Policy through GPMC when password complexity blocked the script
- Setting up NTFS permissions on a department share following Principle of Least Privilege
- Choosing Modify over Full Control so a compromised account cannot escalate

The hardest part was not the build. It was reading "The server is unwilling to process the request" 47 times and learning to diagnose what AD was complaining about.

Full repo with screenshots, scripts, lessons, and the difficulties I hit is on my GitHub.

Open to junior support technician roles and apprenticeships. Always happy to talk shop.

---

## Version 3: Skills-focused

Closed out my latest home lab project: a Windows Server 2022 Active Directory environment with PowerShell automation and NTFS security.

Skills this project hits:
- Server build and configuration
- Active Directory Domain Services
- DNS configuration as part of AD
- Organisational Unit design
- PowerShell scripting for bulk admin tasks (try/catch, idempotency, CSV parsing)
- Group Policy management via GPMC
- File share administration
- NTFS and Share permission layering
- Principle of Least Privilege in practice
- Real-world troubleshooting and log analysis

Built into the project documentation:
- Every screenshot taken at a key moment
- A difficulties file for each section showing where I went wrong and what I fixed
- A lessons file for each section showing what I took away
- Working PowerShell script with a sample CSV

Honest note in the repo about a separate osTicket attempt that did not pan out, what broke, and why I pivoted. Showing the misses matters as much as showing the wins.

GitHub link in the comments. Looking for junior IT support and apprenticeship opportunities.
