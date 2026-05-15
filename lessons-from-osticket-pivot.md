# Lessons from the osTicket Pivot

Before the Active Directory home lab, I tried to build a local osTicket helpdesk on XAMPP for the portfolio. That project did not finish. Logging it here because pretending it never happened would not be honest, and the troubleshooting itself taught me a lot.

---

## The goal

Deploy osTicket v1.18.3 on Windows 11 using XAMPP (Apache + MariaDB + PHP 8.2.12) so I had a working ticketing system to screenshot for LinkedIn.

## What worked

- Installed XAMPP and got Apache plus MariaDB running on default ports
- Created the `osticket` database in phpMyAdmin with the correct `utf8mb4` collation
- Successfully renamed `ost-sampleconfig.php` to `ost-config.php`
- Reached the osTicket web installer form

## What broke

The web installer threw a 500 Internal Server Error every time I clicked Install Now. Reading the Apache error log told the real story:

```
PHP Fatal error: Uncaught mysqli_sql_exception: Access denied for user 'root'@'localhost' (using password: YES)
```

Followed later by:

```
PHP Fatal error: Uncaught Error: Call to undefined function osTicket\Mail\_S()
```

## Root cause

Two problems chained together:

1. MariaDB authentication state on root@localhost got corrupted. Resets via `--skip-grant-tables` did not stick because the service kept hanging on Windows 11.
2. The gettext PHP extension was not loading even after uncommenting it in php.ini. This caused osTicket's error handler to crash while trying to translate its own error message, producing a blank screen instead of a useful diagnostic.

I attempted manual SQL schema injection from `install-mysql.sql` after replacing `%TABLE_PREFIX%` with `ost_`. The tables imported (133 queries successful) but the live site still 500'd because the seed data was incomplete and the config layer was unstable.

## Why I pivoted

Hours in, the environment was too corrupted to recover cleanly. The choices were:
1. Fully uninstall and reinstall XAMPP
2. Move osTicket to an Azure VM
3. Switch to a different project that better matches the apprenticeship path

I chose option 3. An Active Directory home lab on Windows Server 2022 demonstrates more of the skills a junior support technician uses daily (identity management, Group Policy, PowerShell, file shares) than a helpdesk app does. The hours spent on osTicket were not wasted because the troubleshooting itself was the lesson.

## What I would do differently

- Run osTicket inside a clean Windows Server VM from the start instead of on my main Windows 11 machine, so corrupting the database state did not corrupt my actual workstation
- Verify all required PHP extensions load via `phpinfo()` before clicking Install Now
- Take a VirtualBox snapshot before any database operation so I had a known-good rollback point
- Set a time box on debugging before pivoting. 2 hours is a reasonable limit on a stuck install

## What I took into the AD project

- Read the log first. The actual error message tells you what is broken faster than any guess
- Snapshots in VirtualBox are a save game. Use them
- A wider, more relevant project beats a narrow project that almost worked
