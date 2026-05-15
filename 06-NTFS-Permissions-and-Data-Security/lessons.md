# Lessons Learned - NTFS Permissions and Data Security

## Share permissions versus NTFS permissions

The two-layer model is the most asked permissions question in junior interviews. Summary:

- Share permissions only apply when accessing the folder over the network
- NTFS permissions always apply, whether accessing locally or over the network
- The effective access is the most restrictive of the two

Industry standard pattern:
1. Set Share permissions to Full Control for Authenticated Users or Domain Users
2. Use NTFS permissions to enforce the actual access control
3. Document the NTFS permissions because they are the single source of truth

## Inheritance is your friend until it is not

NTFS permissions inherit from parent to child by default. This is great for keeping permissions consistent across a folder tree. It becomes a problem when you want a child folder to be more locked down than its parent.

Two options when you need to break the chain:

- Disable inheritance and convert (keeps current effective permissions but makes them editable)
- Disable inheritance and remove all (starts from zero, you rebuild the ACL manually)

Most of the time, Convert is the right choice.

## The PoLP rule of thumb

When in doubt, give the user the lowest permission level that still lets them do their job. If they cannot do something, they will tell you, and you can grant more. If they can do too much, you might never find out until something breaks or gets leaked.

NTFS permission levels in order of increasing power:

1. List folder contents - see filenames only, no content access
2. Read - open and read files
3. Read and Execute - read plus run programs
4. Write - create new files in the folder
5. Modify - read, write, delete, change. The right default for most users
6. Full Control - Modify plus change permissions and take ownership. Admins and service accounts only

## Default groups to leave alone

When locking down an ACL, do not remove these unless you know what you are doing:

- SYSTEM. The Windows OS itself. Needed for backup, indexing, antivirus, etc.
- Administrators. Local admins need access for maintenance and recovery
- CREATOR OWNER. Whoever creates a file gets ownership rights to their own files. Removing this can cause permission weirdness

The one to remove is usually Users (the default everyone-on-this-machine group).

## File share permissions in real environments

Most real companies use a model like this:

- File server stores all department shares
- Each department has its own share (e.g. `\\fs01\Finance$`)
- Access is granted via security groups, not individual users
- New starters get added to the right group as part of onboarding
- Group membership is reviewed quarterly (an audit requirement)

The group-based pattern is more scalable than per-user permissions. If you ever inherit a domain where every share has individual users on the ACL, that is a sign of an immature admin team.

## What I would change next time

For a portfolio extension:

- Move from per-user permissions to group-based. Create a `GG-IT-Support` global group, add Sarah to it, and grant the group Modify instead of the user directly. This is the pattern senior admins use.
- Add Access-Based Enumeration (ABE) to the share so users only see folders they have access to. This hides the existence of folders they cannot access, which is a small but useful security feature.
- Set up auditing on the IT_Private folder so any access is logged to the Security event log. Useful for compliance and investigation.
- Demonstrate the difference by logging in as the Employees user (not in IT) and trying to access IT_Private. Confirm access is denied. That is the proof the lockdown works.
