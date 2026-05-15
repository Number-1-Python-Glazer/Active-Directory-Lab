# Lessons Learned - Server Setup and Configuration

## On virtualisation

VirtualBox is treated as a real computer by the OS inside it. That means BIOS-style boot order, ISO ejection, and driver installation all behave like physical hardware. Understanding this saves time because every problem maps to something a tech would do on a real workstation.

## On Windows Server vs Windows 10/11

Windows Server 2022 needs the Desktop Experience option during install if you want a usable GUI. Without it you get Server Core, which is command-line only. For learning, Desktop Experience is the right pick. In production, Server Core has a smaller attack surface and is what most senior admins prefer.

## On static IP for a Domain Controller

A Domain Controller has to use a static IP. If the IP changes, every client computer pointing at it for DNS lookups will fail to find the domain. The DC also has to point its own DNS at itself (127.0.0.1) because it becomes the DNS server for the domain after promotion.

## On Guest Additions

These are not optional for a usable VM. Without them, the screen does not resize, clipboard sharing fails, and the mouse capture behaviour is clunky. Installing them is the same idea as installing chipset drivers on a fresh Windows PC.

## On naming conventions

DC-01 follows industry standard naming. The "DC" prefix tells you the role (Domain Controller), and the "-01" lets you scale to DC-02, DC-03 in larger environments with multiple controllers for redundancy. Small detail but it shows you think like an admin.

## What I would change next time

I would take a VirtualBox snapshot right after Guest Additions finished installing. That gives me a clean rollback point if I break something during the AD setup. Snapshots are free, take seconds, and have saved real careers.
