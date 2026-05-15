# Lessons Learned - User Management and Organisation

## OUs are about Group Policy, not folders

When I first saw the OU structure I thought it was a fancy way to organise users into folders. The real reason OUs exist is Group Policy targeting. You link a GPO to an OU and every object in that OU gets the policy. If your OU structure does not match your policy requirements, you have to use security filtering or WMI filters as workarounds, which gets messy.

Plan your OUs around the policies you want to apply, not how you want to display users in a list.

## The principle of separation of duties

Built-in Administrator is the most strong account in the domain. Treating it as a daily driver means:
- Every action is logged as "Administrator" so audit trails are useless
- A compromised browser session immediately gives an attacker domain admin
- Mistakes have maximum blast radius

The fix is a tiered admin model. Senior admins use three accounts each: standard daily user, server admin account, and domain admin account. They only log in with the highest privilege when they need it. This is called the Microsoft Privileged Access Workstation (PAW) model.

## CN containers versus OUs

The default Users and Computers containers in AD are CN containers, not OUs. The visible difference is the icon. The functional difference is huge: CN containers cannot have GPOs linked to them directly. This is why every new domain admin gets caught wondering why their policy is not applying to users in the default Users folder.

## ADUC versus Active Directory Administrative Center

ADUC (Active Directory Users and Computers) is the classic MMC tool. There is a newer one called Active Directory Administrative Center (ADAC) which is more PowerShell-friendly and has the Active Directory Recycle Bin feature. Most senior admins still use ADUC out of habit but knowing both helps.

## Naming conventions matter

A good naming convention is:
- Predictable. Anyone can guess a username from a real name
- Unique. No collisions when two people have the same name
- Indicative. You can tell what an account is for by reading it

For this lab I used:
- Regular users: first initial + surname (`ssmith` for Sarah Smith)
- Admin accounts: forename + `-admin` (`iris-admin`)
- Service accounts: `svc-` prefix (e.g. `svc-backup`)

## What I would change next time

Build the OU hierarchy first, then create users into it. Doing it in the other order means moving objects around afterwards. A bigger lab would have:

- Sites/Regions at the top (e.g. London, Manchester)
- Departments under that (IT, Finance, HR)
- Users, Computers, Groups, Service Accounts as sub-OUs of each department

This is closer to a real enterprise structure and makes GPO inheritance work logically.
