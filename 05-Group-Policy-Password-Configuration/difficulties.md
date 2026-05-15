# Difficulties - Group Policy Password Configuration

## Issue 1: Finding the right GPO

When I first opened Group Policy Management, I saw a lot of nodes (Forest, Sites, Domains, WMI Filters, Starter GPOs, Group Policy Modeling, Group Policy Results). I had no idea which one to click.

What helped: Following the breadcrumb path. The hierarchy is:

- Forest: local.laboratory
- Domains
- local.laboratory
- Default Domain Policy (this is the GPO to edit for password rules)

Lesson: GPMC has a lot of nodes but most admin work happens in the Domains → [your domain] → [policy] path. Sites and WMI filters are advanced topics for later.

---

## Issue 2: Password Policy is under Computer Configuration not User Configuration

I instinctively looked under User Configuration for password settings because passwords are something users have.

What is correct: Password policies live under Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Password Policy. The reason is that password policies are enforced by the machine the user logs into (which validates the password against the DC), not by the user object itself.

Lesson: In Group Policy, "Computer" settings apply to where the user is logging in from, "User" settings apply to who is logging in. Account-related settings (password, lockout) are computer-level because they are enforced at authentication time.

---

## Issue 3: The change did not apply right away

After disabling complexity, I re-ran the bulk user script and it still failed with the same error.

Cause: Group Policy does not refresh instantly. The Domain Controller has a 5-minute refresh cycle by default.

Fix: Ran `gpupdate /force` in PowerShell. This forced an immediate policy refresh. After that, the script worked.

Lesson: Whenever you change a GPO, `gpupdate /force` is your friend. Without it, you sit around wondering why your change is not working when it has not refreshed yet.

---

## Issue 4: Worrying about the security implications

Even though this is a lab, I felt weird disabling a security control. I had to think through whether it was safe.

Reasoning that made me OK with it:
- The lab is fully isolated. No internet exposure, no real users, no real data
- The change is documented and explained as a deliberate, time-bound lab decision
- The right answer for production (Fine-Grained Password Policies, passwordless auth) is also noted in the README so a reader knows I understand the trade-off

Lesson: When you deliberately weaken a control for a valid reason, document it clearly. Auditors and senior admins want to see that you understood what you were doing was risky and that you mitigated the risk (in this case, by isolating the lab).
