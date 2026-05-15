# Lessons Learned - Group Policy Password Configuration

## What Group Policy is

Group Policy is a system for centralised configuration management in a Windows domain. Instead of clicking through Control Panel on every PC, you define settings once in a GPO and link it to an OU. Every computer and user inside that OU receives the settings automatically.

A typical mid-size company has dozens of GPOs covering:
- Password and lockout policies
- Drive mappings
- Printer deployment
- Desktop wallpaper and screen locks
- Software installation
- Windows Update settings
- USB device restrictions
- Browser homepage and bookmarks

## The two halves of every GPO

Every GPO has a Computer Configuration half and a User Configuration half:

- Computer Configuration applies when the machine boots, regardless of who logs in
- User Configuration applies when a user logs in, regardless of which machine

If a setting affects security at the machine level (password policy, firewall, BitLocker), it lives under Computer Configuration. If a setting affects the user's personal experience (desktop wallpaper, Start menu layout), it lives under User Configuration.

## Why account policies are special

Password policies, account lockout policies, and Kerberos policies have to be set at the domain root. You cannot link a GPO with these settings to a regular OU and expect it to work. If you need different password requirements for a specific group (e.g. stricter for admins), you have to use Fine-Grained Password Policies (FGPP) which are configured through Active Directory Administrative Center, not GPMC.

## GPO precedence (LSDOU)

When multiple GPOs apply to the same object, they merge in this order:

1. Local Group Policy (on the workstation itself)
2. Site GPOs
3. Domain GPOs (e.g. Default Domain Policy)
4. OU GPOs, in order from top to bottom of the OU hierarchy

Settings in later-applied GPOs override earlier ones. This is the LSDOU rule that every admin memorises.

## gpupdate and gpresult

Two commands every junior tech needs:

- `gpupdate /force` to push policy refresh immediately
- `gpresult /h report.html` to generate an HTML report of every policy applied to the current user and machine

`gpresult` is the answer to "why is this policy not working?" tickets. It tells you exactly which policies applied, which were blocked, and why.

## What I would change next time

For a portfolio extension I would:

- Create a Fine-Grained Password Policy that applies a weaker password rule only to a specific OU, rather than disabling complexity domain-wide. This is the more professional solution.
- Add a GPO that maps a network drive to all users in the Employees OU.
- Add a GPO that sets a corporate desktop wallpaper.
- Demonstrate WMI filtering by creating a policy that only applies to laptops, not desktops.

These extensions would turn the lab from "I can install AD" into "I can manage a fleet."
