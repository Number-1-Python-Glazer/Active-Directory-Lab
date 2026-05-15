# Difficulties - Active Directory Installation

## Issue 1: "Create DNS delegation" warning

During the promotion wizard, the DNS Options page showed a yellow warning saying a delegation for this DNS server could not be created.

What it meant: Active Directory was looking for a parent DNS zone to register itself with. Because this forest is brand new and `local.laboratory` does not exist anywhere else, there is no parent to delegate from.

Fix: Left the DNS delegation box unchecked and clicked Next. The wizard handled the rest by installing its own DNS role.

Lesson: Read the warnings rather than panicking at them. Many AD wizard warnings are normal for a first-time forest setup.

---

## Issue 2: Long reboot after promotion

The server took noticeably longer to boot after the promotion install completed.

Cause: The first boot after a DC promotion has to initialise the AD database (NTDS.dit), set up SYSVOL, and replicate initial directory data even on a single-server forest.

Fix: Waited it out. The boot took around 3 to 4 minutes which is normal for first-time promotion. Subsequent boots are much faster.

Lesson: Patience. The longest reboots are usually the ones doing the most important work.

---

## Issue 3: Domain name choice

I initially considered using `lab.local` because it is the example I had seen in tutorials. The `.local` TLD is fine for a lab but has problems in production. Apple devices use `.local` for mDNS (Bonjour) and it conflicts with some real-world DNS resolution.

What I picked: `local.laboratory` instead. This is still safely fake (the `.laboratory` TLD is not used on the public internet) and avoids the `.local` conflict.

Lesson: Even in a lab, picking names like a professional matters. If you only ever practise with `.local`, you will pick `.local` in production and create real conflicts. Microsoft now recommends using a subdomain of a real owned domain (e.g. `ad.yourcompany.com`) for production deployments.

---

## Issue 4: DSRM password

The wizard asks for a Directory Services Restore Mode password, which is separate from the Administrator password. I almost reused the Administrator password.

Cause: Tutorials often skip past explaining what DSRM is for.

What DSRM does: It is the recovery password used to boot the DC into Safe Mode for repair operations on the AD database itself. If the domain breaks badly, this is the password you use to log in locally and fix it. It is meant to be different from the regular Administrator password for security reasons.

Fix: Set a unique, strong DSRM password and recorded it in a safe place outside the VM.

Lesson: Read the wizard text rather than clicking through. DSRM is a real recovery tool and treating it like any old password is a mistake that bites you when the domain is down.
