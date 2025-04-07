# Blackout FAQ

## General Questions

### What exactly is Blackout?
Blackout is a specialized tool designed to disable and remove GoGuardian monitoring software from Chromebooks. It works by identifying and removing GoGuardian extensions, modifying policy files, and blocking connections to GoGuardian servers.

### Is using Blackout legal?
Blackout is created for educational purposes. While the tool itself is legal, using it to bypass monitoring software on school-owned devices may violate your school's policies or terms of service. Always make sure you have permission to modify devices you don't own.

### Will my school know I'm using Blackout?
Possibly. While Blackout attempts to operate discreetly, sophisticated monitoring systems might detect attempts to modify system files or policies. Some schools also have physical monitoring or periodic checks.

## Technical Questions

### Why does my school block Developer Mode?
Schools block Developer Mode because it provides deeper access to the Chromebook's system, making it possible to remove or bypass monitoring tools like GoGuardian. It's a security measure to maintain control over school-owned devices.

### Can Blackout work without Developer Mode?
Yes, but with limitations. Blackout can still remove extensions and block domains through various methods outlined in the installation guides, but some features may be less effective or persistent without Dev Mode access.

### Will Blackout remove ALL monitoring from my Chromebook?
Not necessarily. Blackout specifically targets GoGuardian systems. If your school uses multiple monitoring solutions, you might still be monitored by other software. Additionally, some monitoring happens at the network level and can't be blocked by client-side tools.

### Does Blackout need to be run after every reboot?
It depends on your school's setup. Blackout includes a persistence script that tries to maintain its changes across reboots, but some school management systems may reapply policies and extensions automatically. In these cases, you might need to run Blackout again.

## Installation Questions

### I can't access shell or terminal. Can I still use Blackout?
If you can't access a shell through any of the methods in the installation guide, you might not be able to use Blackout directly. However, you could still try using the USB recovery method, which doesn't require shell access on the Chromebook itself.

### Why is the USB method more reliable than direct installation?
The USB method works by modifying the Chromebook's system while it's not running. This bypasses many of the protections that prevent modifications to the system. It can modify files that would normally be protected by the OS when it's running.

### Will installing Blackout delete my files?
Using Blackout itself shouldn't delete your personal files. However, some installation methods (particularly the USB recovery method) involve processes that can potentially lead to data loss if done incorrectly. Always back up important files before attempting to install Blackout.

### My school blocked all USB boot options. What can I do?
If USB booting is blocked, you'll need to try one of the other methods, such as gaining shell access through the Linux Development Environment or looking for specific exploits for your Chromebook model. Note that these methods may be less reliable.

## Troubleshooting

### Blackout ran successfully, but GoGuardian is still active. Why?
This could happen for several reasons:
1. GoGuardian components are being reinstalled by enterprise policies
2. The specific GoGuardian version used by your school might not be targeted by Blackout
3. You might need to restart your browser or device for changes to take effect
4. The installation might not have had sufficient permissions to modify all necessary files

### I get "Permission denied" errors when running the script
This usually indicates you need root (administrator) access. Try running the script with sudo: `sudo ./blackout.sh`

### I can't modify the hosts file
The hosts file is often protected. The USB method is the most reliable way to modify it. Alternatively, try running: `mount -o remount,rw /` before attempting to modify the hosts file.

### GoGuardian returns after every reboot
Your school is likely pushing policies on each boot. You have a few options:
1. Set up the persistence script correctly (this is done automatically by Blackout)
2. Run Blackout after each reboot
3. Try the USB installation method, which may be more effective at disabling automatic reinstallation

## Safety and Recovery

### How can I undo Blackout's changes?
Blackout creates backup files with the extension `.blackout_backup`. To restore these:
1. For hosts file: `sudo cp /etc/hosts.blackout_backup /etc/hosts`
2. For policy files: Find the files with `.blackout_backup` and restore them
3. For complete reversal, you may need to powerwash your Chromebook

### Will Blackout break my Chromebook?
When used as intended, Blackout should not cause permanent damage to your Chromebook. However, modifying system files always carries some risk. In a worst-case scenario, you might need to recover your Chromebook using the official recovery process.

### What should I do if my Chromebook won't boot after using Blackout?
If your Chromebook won't boot properly after using Blackout:
1. Try booting in recovery mode (Esc + Refresh + Power)
2. If possible, use the shell in recovery mode to undo changes
3. If necessary, perform a full recovery using the Chromebook Recovery Utility and a USB drive

## Ethical Considerations

### Should I really be using this tool?
That's a personal decision. Consider why monitoring software exists on school devices and whether bypassing it aligns with your values. Remember that monitoring often exists for safety and educational purposes, not just for control.

### What is the developers' stance on using Blackout?
Blackout is developed for educational purposes to demonstrate how monitoring systems work and how they can be analyzed. The developers encourage users to act ethically and respect the policies of organizations that own the devices they use.

---

*Note: This FAQ is for educational information only. The Blackout developers do not encourage violation of school policies or unauthorized modification of devices you do not own.* 