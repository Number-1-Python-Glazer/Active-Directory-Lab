# Difficulties - NTFS Permissions and Data Security

## Issue 1: Confusion between Share and NTFS permissions

When I started this section, I was not sure which permission layer to focus on. The Properties dialog has a Sharing tab and a Security tab and both look like they do the same thing.

What I learned:

- The Sharing tab controls who can reach the folder from the network. If someone is logged into the local console of the server, Share permissions do not apply at all.
- The Security tab (NTFS) controls who can do what once they get to the folder, regardless of whether they came in over the network or locally.

The effective permission is the most restrictive of the two. So if Share grants Full Control but NTFS grants Read only, the user gets Read only.

Best practice: Set Share to Full Control for Domain Users (or Authenticated Users) and use NTFS for the real access control. That way you only manage one set of permissions.

Lesson: When in doubt, NTFS is the source of truth. Share permissions are a coarse outer filter.

---

## Issue 2: Could not remove Users group at first

When I first tried to remove the Users group from the IT_Private folder's Security tab, the Remove button was greyed out.

Cause: The Users entry was inherited from the parent folder. Inherited permissions cannot be edited directly. You have to either:

1. Change the inheritance at the parent folder, or
2. Disable inheritance on the child folder and convert the inherited permissions to explicit

Fix: Clicked Advanced → Disable inheritance → chose "Convert inherited permissions into explicit permissions on this object." After that the Remove button was clickable.

Lesson: If a permission entry is greyed out, it is inherited. Look at the "Inherited from" column in the Advanced Security Settings view to see where it came from.

---

## Issue 3: Choosing "Convert" versus "Remove all"

When you click Disable inheritance, Windows asks if you want to:

- Convert inherited permissions into explicit permissions on this object
- Remove all inherited permissions from this object

I picked Convert. Here is the difference:

- Convert keeps the current permissions but makes them editable. Safe default. You start from where you are and only change what needs changing.
- Remove all wipes everything. You start with an empty ACL and add back only what you want. This is what you would do for an extremely sensitive folder where you want to be certain nothing is silently inherited.

For this lab, Convert was the right pick because I wanted to keep SYSTEM, Administrators, and CREATOR OWNER. Removing all would have meant adding those back manually.

Lesson: Convert is the friendly default. Remove all is the paranoid default. Pick based on how strict the folder needs to be.

---

## Issue 4: Was tempted to grant Full Control

When adding Sarah Smith to the ACL, the Full Control tick box was right there and it felt easier than ticking Modify, Read & Execute, List folder contents, Read, and Write separately.

Why I did not: Full Control includes the right to change permissions on the folder itself (Change Permissions) and to take ownership (Take Ownership). If Sarah's account is ever compromised, an attacker with Full Control can:

1. Grant themselves access to other parts of the share by editing permissions
2. Take ownership and lock out the legitimate Administrators
3. Use the folder as a persistence foothold

Modify gives Sarah everything she needs to work with the files (read, write, delete, rename, create) without giving her the security-modification powers. That is PoLP in practice.

Lesson: Full Control is almost never the right answer for a user account. Service accounts, Administrators, and SYSTEM get Full Control. Regular users get Modify at most.

---

## Issue 5: Check Names was rejecting "Sarah Smith"

When I tried to add Sarah Smith to the ACL, I typed her full name and Check Names did not resolve it.

Cause: Check Names looks at the SamAccountName (logon name) by default, not the display name. Sarah's SamAccountName is `ssmith`, not "Sarah Smith".

Fix: Typed `ssmith` instead. Check Names resolved it and showed "Sarah Smith (ssmith@local.laboratory)" with the underline confirming the match.

Lesson: When adding users to permissions, type the username (SamAccountName), not the display name. The display name is for showing, the username is for searching.
