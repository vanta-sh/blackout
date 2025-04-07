# Blackout Installation Guide (No Developer Mode Required)

This guide provides detailed instructions for installing Blackout on a Chromebook without requiring developer mode.

## Important Warnings

- **BACKUP YOUR DATA**: Some of these methods may result in data loss if performed incorrectly
- **EDUCATIONAL USE ONLY**: This tool is for educational purposes; use at your own risk
- **POTENTIAL CONSEQUENCES**: Using this tool may violate your school's policies

## Method 1: Temporary Shell Access

This method works if you can gain temporary shell access through a Linux container, Secure Shell app, or other means.

### Prerequisites:
- A way to access shell/terminal on your Chromebook
- Administrator password (for sudo commands)

### Steps:

1. **Enable Linux Development Environment** (if available):
   - Go to Settings > Advanced > Developers > Linux development environment
   - Click "Turn On" and follow the setup instructions
   - This will give you a Linux terminal with shell access

2. **Open Terminal and Get Root Access**:
   ```bash
   sudo -i
   # Enter your password when prompted
   ```

3. **Download and Run Blackout**:
   ```bash
   curl -sL https://raw.githubusercontent.com/yourusername/blackout/main/blackout.sh -o blackout.sh
   chmod +x blackout.sh
   ./blackout.sh
   ```

4. **Verify Installation**:
   - Check if the script completed successfully
   - Look for "BLACKOUT COMPLETE" message
   - Restart your Chromebook when prompted

---

## Method 2: USB Recovery Environment Method

This method boots your Chromebook into a recovery environment, giving you shell access to the system files.

### Prerequisites:
- 8GB+ USB drive (will be erased)
- Access to another computer to create the recovery USB
- Basic knowledge of Linux terminal commands

### Steps:

1. **Create a ChromeOS Recovery USB**:
   - On another computer, install the [Chromebook Recovery Utility](https://chrome.google.com/webstore/detail/chromebook-recovery-utili/pocpnlppkickgojjlmhdmidojbmbodfm)
   - Launch the utility and follow instructions to create a recovery USB for your specific Chromebook model
   
2. **Add Blackout to the USB**:
   - After creating the recovery USB, do not eject it
   - Download the Blackout script to the USB drive:
     ```
     curl -sL https://raw.githubusercontent.com/yourusername/blackout/main/blackout.sh -o /path/to/usb/blackout.sh
     chmod +x /path/to/usb/blackout.sh
     ```

3. **Boot from the USB**:
   - Insert the USB drive into your Chromebook
   - Power off the Chromebook completely
   - Press and hold Esc + Refresh (↻) + Power button
   - Release when you see the recovery screen

4. **Access Shell in Recovery Mode**:
   - At the recovery screen, press Ctrl+Alt+F2 to switch to a terminal
   - Log in as "chronos" (no password required)

5. **Mount Internal Storage**:
   ```bash
   # Create mount point
   mkdir -p /tmp/rootfs
   
   # Find your internal storage device
   lsblk
   
   # Mount it (device name might differ, usually mmcblk0p3 or sda3)
   mount /dev/mmcblk0p3 /tmp/rootfs
   ```

6. **Mount the USB Drive**:
   ```bash
   # Find the USB drive
   lsblk
   
   # Create mount point and mount it
   mkdir -p /tmp/usb
   mount /dev/sdb1 /tmp/usb  # Change sdb1 to your USB partition
   ```

7. **Run Blackout on the Internal Storage**:
   ```bash
   # Navigate to the USB
   cd /tmp/usb
   
   # Run the script with target parameter
   bash blackout.sh --target=/tmp/rootfs
   ```

8. **Reboot Normally**:
   ```bash
   # Cleanup and reboot
   umount /tmp/rootfs
   umount /tmp/usb
   reboot
   ```

---

## Method 3: Guest Mode Exploits

Some Chromebook models have vulnerabilities that allow shell access from guest mode. These vary by model and ChromeOS version.

### Prerequisites:
- Knowledge of specific vulnerabilities for your Chromebook model
- Guest mode access enabled on your Chromebook

### General Steps:

1. **Boot into Guest Mode**:
   - From the login screen, click "Browse as Guest"

2. **Try Common Shell Access Methods**:
   - Press Ctrl+Alt+T to open crosh (Chrome OS shell)
   - Try various commands that might escalate to a full shell:
     ```
     shell
     ```
     or
     ```
     chronos
     ```
     
3. **For Specific Models**:
   
   **Example: Shell Access on Certain Older Models**:
   - Press Ctrl+Alt+T for crosh
   - Type: `shell`
   - If successful, you'll now have a limited shell
   - Try: `sudo -i` to get root access
   
   **Known URL Bar Exploits**:
   - Some versions allow special URLs to access system features
   - Try opening: `chrome://system` or `chrome://chrome-urls`
   - Look for diagnostic tools that might provide shell access

4. **If You Gain Shell Access**:
   - Follow Method 1 to download and run Blackout

---

## Troubleshooting

### "Permission denied" errors:
- You need root access (sudo) to run most Blackout functions
- Try running with `sudo ./blackout.sh` or `sudo bash blackout.sh`

### "Read-only file system" errors:
- The system partition is mounted read-only
- The script attempts to remount it read-write, but this may fail without developer mode
- Try the USB method, which manipulates the system while it's not running

### Blackout runs but GoGuardian returns after reboot:
- The school might be pushing policies on each boot
- The persistence script should help, but might be removed by admin policies
- Run Blackout again after each reboot, or try modifying the persistence approach

### Can't gain shell access through any method:
- Your school might have locked down all access pathways
- Consider researching specific vulnerabilities for your exact Chromebook model and OS version

---

## After Installation

1. **Check Functionality**:
   - After rebooting, verify if GoGuardian is still active
   - The persistence script should keep it disabled

2. **Maintaining Protection**:
   - If your school pushes new policies, you may need to run Blackout again
   - Consider creating a periodic task to run the persistence script

3. **Removing Blackout**:
   If you need to remove Blackout:
   ```bash
   sudo rm /usr/local/bin/blackout_persist.sh
   sudo rm /etc/systemd/system/blackout.service
   sudo systemctl daemon-reload
   ```
   Then restore any backups created during installation. 