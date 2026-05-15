# Difficulties - PowerShell Bulk User Automation

This was the most error-heavy section of the project. Documenting every failure here because the troubleshooting was where the real learning happened.

---

## Issue 1: File not found

First run of the script crashed instantly with a red error saying it could not find the CSV.

What I tried: Checked that I had saved `users.csv` on the C: drive. The file was there.

The actual cause: Windows was hiding the file extension. The file was saved as `users.csv.txt`. Notepad had silently appended `.txt` when saving, but Explorer was hiding the extension so it looked correct.

Fix:
1. Opened File Explorer
2. View tab → ticked "File name extensions"
3. Saw the real filename: `users.csv.txt`
4. Renamed it to `users.csv`
5. Re-ran the script

Lesson: Turn on file extensions on every Windows machine you touch. Hidden extensions are a security risk too because malware uses fake extensions to look like documents (e.g. `invoice.pdf.exe` showing as `invoice.pdf`).

---

## Issue 2: Wrong domain path in the script

After fixing the filename, the script ran but every OU creation and user creation failed with "The server is unwilling to process the request."

What I tried: Re-reading my own code. The script had `DC=lab,DC=local` hardcoded as the domain path because that is the example I had been working from. My actual domain was `local.laboratory`, which translates to `DC=local,DC=laboratory`.

The cause: I was telling AD to create objects in a domain that did not exist.

Fix: Updated the `$DomainPath` variable to `"DC=local,DC=laboratory"` and the UPN suffix to `"local.laboratory"`.

Lesson: When a script says the server is "unwilling," check if you are pointing at the right server first. Half of all AD path errors are typos in the Distinguished Name (DN).

---

## Issue 3: "The server is unwilling to process the request" (still)

Even after the path fix, the OUs created successfully but every user creation failed with the same "unwilling to process" message.

What I tried first: Adjusted the password. Used `P@ssword123!`, then `root11root!!`. Neither helped.

The cause: The default Domain Default Policy enforces password complexity rules that were rejecting my chosen password values. Specifically the policy requires:
- Minimum length
- At least three of: uppercase, lowercase, digit, symbol
- Not containing the user's own name or significant parts of it

The error message was vague because "unwilling to process" is AD's polite way of saying "you broke a policy I will not name."

Fix: I went into Group Policy Management (covered in detail in section 05) and disabled the password complexity requirement for the lab. After running `gpupdate /force` to apply the change, the script worked.

Lesson: AD errors are deliberately vague for security reasons. They do not want to tell an attacker exactly which policy blocked them. When you see "unwilling to process," your first guess should be a password policy or permission issue.

---

## Issue 4: Race condition between OU creation and user creation

In an earlier version of the script, I had the OU and user creation interleaved in one loop:

```
foreach user:
 create OU if missing
 create user inside that OU
```

This failed for the second user in the same department because:
1. First user triggers OU creation
2. AD says "OK, OU created"
3. Script immediately tries to make second user in that OU
4. AD has not finished replicating the OU yet
5. Error: server unwilling to process

Fix: Split the script into two passes. First pass creates all unique OUs and sleeps for 2 seconds. Second pass creates all users.

```
# Pass 1
foreach unique department:
 create OU if missing

sleep 2 seconds

# Pass 2
foreach user:
 create user
```

Lesson: This is called a "race condition" in programming. It happens when two operations depend on each other but run too quickly for the dependency to settle. Adding a short delay or splitting the logic into phases is the standard fix.

---

## Issue 5: OUs leftover from failed runs

After several failed script attempts, my domain had leftover empty OUs (IT, Security, etc.) sitting around from incomplete runs. When I tried to re-run a clean version of the script, it threw errors saying the OUs already existed.

Fix: Added an existence check (`if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$dept'"))`) before every OU creation so the script is idempotent. Running it twice no longer causes errors. Existing OUs are skipped with a "skipping" message.

Lesson: Idempotent scripts are scripts you can run safely multiple times. This is a core skill for automation work. Every change script you write for production should either:
- Check if the change is already applied before doing anything
- Or roll back cleanly if it fails halfway through
