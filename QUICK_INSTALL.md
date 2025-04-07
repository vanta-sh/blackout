# Blackout Quick Installation Guide

Below are simple one-line commands that will download and run Blackout automatically. Choose the method that works best for your situation.

## Important Warning

**EDUCATIONAL PURPOSES ONLY**: This tool is for educational purposes; use at your own risk. Using this tool may violate your school's policies.

## One-Line Installation Commands

### Method 1: Direct Installation (Normal ChromeOS)

If you have shell access on your Chromebook, paste this command:

```bash
curl -sL https://raw.githubusercontent.com/vanta-sh/blackout/main/blackout_installer.sh | sudo bash
```

### Method 2: Recovery Mode Installation

If you're in recovery mode and need to modify your internal storage:

```bash
curl -sL https://raw.githubusercontent.com/vanta-sh/blackout/main/blackout_installer.sh | sudo bash
```

The installer will automatically detect that you're in recovery mode and attempt to mount your internal storage.

### Method 3: Manual Download and Install

If you prefer to examine the script before running it:

```bash
# Download the installer
curl -sL https://raw.githubusercontent.com/vanta-sh/blackout/main/blackout_installer.sh -o blackout_installer.sh

# Make it executable
chmod +x blackout_installer.sh

# Run it with sudo
sudo ./blackout_installer.sh
```

## What These Commands Do

1. Download the Blackout installer script
2. Run the installer with root privileges
3. The installer will:
   - Check your environment (normal ChromeOS or recovery mode)
   - Download the Blackout script
   - Run Blackout with appropriate parameters
   - Clean up temporary files

## After Installation

Blackout will likely ask you to restart your Chromebook to apply all changes. Follow the on-screen instructions.

## Verification

After restarting, GoGuardian should be disabled. You can verify this by checking if:

1. GoGuardian extension icons are gone from Chrome
2. GoGuardian monitoring messages no longer appear
3. Previously blocked sites are now accessible

If GoGuardian reappears after some time, you may need to run the installer again.

---

For more detailed instructions, see the full [INSTALLATION.md](INSTALLATION.md) file. 
