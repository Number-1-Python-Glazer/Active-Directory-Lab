# Lessons Learned - Active Directory Installation

## Forest, tree, domain - what the hierarchy means

Active Directory has a layered structure:

- Forest: the top of the tree. Holds shared schema and security boundary.
- Tree: a set of domains that share a contiguous DNS namespace.
- Domain: the unit of administration. Users, computers, and policies live here.

For a single-server lab, the forest, the tree, and the domain are all the same thing (`local.laboratory`). Real enterprises grow into multiple domains under one forest or even multiple trees.

## AD and DNS are best friends

You cannot have working AD without working DNS. Every domain join, every user login, every Group Policy lookup starts with a DNS query. If DNS breaks, the domain looks broken. This is the single most common cause of "the domain is down" tickets in real support work.

## What the yellow flag means in Server Manager

The yellow flag in the top right of Server Manager is the post-deployment configuration alert. After installing a role, this flag is where the wizard goes to ask you to finish configuration. If you ever wonder "I installed a role, now what" the answer is almost always to click that yellow flag.

## Functional levels explained simply

The forest and domain functional level set the minimum version of Windows Server that any DC in the environment has to run. Setting it to Server 2016 (the current default) lets the forest use every modern feature. You can raise this later but you cannot lower it without rebuilding the domain. For a fresh forest, take the default.

## Why I left default file paths

The wizard suggests putting the AD database, log files, and SYSVOL in `C:\Windows\NTDS` and `C:\Windows\SYSVOL`. In production these often go to dedicated drives for performance and recoverability. In a lab on a single virtual disk, the defaults are fine and changing them would be cosmetic.

## What I would change next time

For a production-style lab, I would:
- Use a subdomain of a real domain I own (e.g. `ad.iris-portfolio.com`) instead of a fake TLD
- Build a second DC (DC-02) and demonstrate replication
- Add a dedicated DNS forwarder for external lookups
