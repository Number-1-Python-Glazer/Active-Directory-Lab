# Difficulties - Server Setup and Configuration

## Issue 1: "Microsoft cannot find the software license terms"

The first time I tried to boot the VM, the Windows installer crashed with this error before I even saw the language selection screen.

What I tried first: rebooting the VM. Did not work.

What fixed it: VirtualBox was trying to do an Unattended Installation. It was injecting a hidden `autounattend.xml` file into the VM that did not match the Evaluation ISO. The fix was to delete the VM, recreate it, and tick "Skip Unattended Installation" on the first screen of the new-VM wizard.

Lesson: Unattended installs are smart in theory but only when the answer file matches the OS image. For a manual lab, skip them.

---

## Issue 2: Boot loop on "Press any key to boot from CD or DVD"

After installation finished and the VM rebooted, it kept landing back at the Windows installer instead of booting my freshly installed OS.

Cause: The ISO was still mounted as an optical drive, and the boot order put CD-ROM ahead of the hard disk.

Fix:
1. Devices menu in VirtualBox
2. Optical Drives
3. Remove Disk from Virtual Drive
4. Reset the VM

Then in Settings → System, I moved Hard Disk to the top of the boot order and unchecked Optical and Floppy.

Lesson: After any OS install, eject the install media. This is the same as pulling a USB stick out of a real PC.

---

## Issue 3: Mouse teleporting to the top of the screen

After installing Guest Additions, my cursor was jumping uncontrollably whenever I moved it inside the VM window.

Cause: Conflict between VirtualBox Mouse Integration and the new Guest Additions drivers initialising.

Fix: Toggled Input → Mouse Integration off then on. Pressed the Host Key (Right Ctrl) to release focus when stuck. Restarted the VM once Guest Additions finished installing.

Lesson: Drivers need a clean reboot to settle. Half-installed drivers cause weird input glitches.

---

## Issue 4: Blank blue screen on first boot

After the install finished and the VM restarted, the screen sat on a solid blue background for several minutes with no text or login prompt.

Cause: The virtual graphics controller had stalled during the Out-of-Box Experience.

Fix: Did a hard reset from Machine → Reset. The second boot went through cleanly. If it had stalled again, the next step would have been changing the Graphics Controller from VBoxVGA to VBoxSVGA in the Display settings.

Lesson: First boots after OS install are slow because Windows is generating a unique machine SID and configuring devices. Give it five minutes before assuming it has crashed.
