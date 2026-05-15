# Difficulties - User Management and Organisation

## Issue 1: Wondering why the default Users container is not an OU

When I first opened ADUC, I noticed the Users folder looked different from the custom OUs I created later. It has a different icon.

What is going on: The default Users and Computers containers are not Organisational Units. They are CN (Common Name) containers. The difference matters because Group Policy Objects cannot be linked directly to CN containers, only to OUs. This is why best practice says move new accounts out of the default Users container into a proper OU as soon as they are created.

Lesson: If you ever wonder why your GPO is not applying to a user, check if that user is sitting in the default Users container instead of an OU. This trips up new admins constantly.

---

## Issue 2: First instinct was to dump users in the default folder

The first user I created I almost left sitting in the default Users container because the New User wizard puts them there by default.

Why this is a bad idea: Default container objects cannot receive Group Policy directly, do not support a logical hierarchy, and look messy. Senior admins will judge you for it.

Fix: Right-clicked the user and selected Move, then chose the `Employees` OU I had created. After that, I made all new users by right-clicking the target OU first and selecting New → User from there. That way the user is born in the right place.

Lesson: Always create users from inside the target OU. It is one less step and one less chance to forget the move.

---

## Issue 3: Worrying that adding users would change DNS

After creating several users and OUs, I was paranoid that something had changed the network or DNS configuration without me noticing.

What I did: Went back to Server Manager → Local Server to verify the static IP was still 172.16.0.1 and Preferred DNS was still 127.0.0.1.

Result: All clean. User and OU changes do not touch network settings.

Lesson: It is fine to be paranoid as a junior admin. Verifying after changes is a habit that prevents real disasters later. The five seconds to check is worth it.

---

## Issue 4: Naming conventions confusion

I had to decide on a username pattern for the admin account. Options I considered:
- `admin-iris`
- `iris-admin`
- `iris.admin`
- `i.iris`

What I picked: First initial plus surname for regular users (`ssmith`, `jbond`), and `firstname-admin` for privileged accounts. The clear `-admin` suffix on privileged accounts means anyone scanning a log file can instantly see when a privileged account did something.

Lesson: Naming conventions are not exciting but they are one of the most-asked interview questions for a reason. Pick a pattern early and stick to it. Switching halfway through a domain build creates inconsistency that haunts you later.
