# BLACKOUT

**Surveillance ends here.**  
*Blackout* is a surgical Chromebook utility designed to detect and remove GoGuardian from your system.  
Built for freedom. Run in silence. Leave no trace.

---

## ⚠️ DISCLAIMER

This tool is for educational and ethical use **only**.  
By using Blackout, you agree that:

- You take full responsibility for how it's used.
- You have permission to modify or remove device configurations.
- You understand the potential consequences of using this tool on managed devices.

---

## ❓ What is Blackout?

Blackout is a shell script tool designed to remove GoGuardian components from **Chromebooks** without requiring developer mode.
It operates by locating known GoGuardian services, extensions, and policies, and removing them with precision.

---

## 🧩 Features

- 🔍 **Extension Scanner** – Finds and flags GoGuardian-related extensions.
- 🧼 **Policy Wiper** – Cleans out restrictive policies linked to remote control or monitoring.
- 🛡️ **Domain Blocker** – Prevents GoGuardian servers from connecting to your device.
- 🔄 **Persistence** – Maintains protection across reboots when possible.
- 📦 **Modular** – Easy to modify for different school monitoring systems.
- 🔧 **Auto-Installer** – One-command installation that handles everything automatically.

---

## 🛠 Requirements

- Chromebook with shell access (through Secure Shell app or other means)
- Basic knowledge of terminal commands
- USB drive (for one installation method)

---

## 🚀 Quick Installation (One Command)

### Automatic Installation:

```bash
curl -sL https://raw.githubusercontent.com/vanta-sh/blackout/main/blackout_installer.sh | sudo bash
```

This single command will:
1. Download the installer
2. Detect if you're in normal mode or recovery mode
3. Set up appropriate environment
4. Install and run Blackout
5. Clean up after itself

For more installation options, see [QUICK_INSTALL.md](QUICK_INSTALL.md).

---

## 🚀 Manual Installation Methods

### Method 1: Direct Run (Temporary Access)

If you can get temporary shell access or can access the Linux development environment:

1. Open a terminal (Linux terminal or Secure Shell app)
2. Run the following command:
   ```
   curl -sL https://raw.githubusercontent.com/vanta-sh/blackout/main/blackout.sh | sudo bash
   ```
   Or download and run manually:
   ```
   curl -sL https://raw.githubusercontent.com/vanta-sh/blackout/main/blackout.sh -o blackout.sh
   chmod +x blackout.sh
   sudo ./blackout.sh
   ```

### Method 2: USB Boot Method (No Developer Mode Needed)

This method requires creating a bootable USB that can bypass normal startup:

1. Create a ChromeOS recovery USB using the [Chromebook Recovery Utility](https://chrome.google.com/webstore/detail/chromebook-recovery-utili/pocpnlppkickgojjlmhdmidojbmbodfm)
2. Download the Blackout script to the USB drive
3. Boot from the USB drive (press Esc + Refresh + Power)
4. When in the recovery environment, press Ctrl+Alt+F2 to open a shell
5. Mount your Chromebook's internal storage:
   ```
   mkdir -p /tmp/rootfs
   mount /dev/mmcblk0p3 /tmp/rootfs  # Your device name might differ
   ```
6. Navigate to the USB drive and run the script with the internal storage path:
   ```
   cd /tmp/usb  # Mount point of your USB drive
   sudo bash blackout.sh --target=/tmp/rootfs
   ```
7. Restart your Chromebook normally

For detailed instructions, see [INSTALLATION.md](INSTALLATION.md).

---

## 🔧 Usage

Once installed, Blackout works automatically to block GoGuardian.

To check status or manually run:
```
sudo /usr/local/bin/blackout_persist.sh
```

---

## 📦 What Blackout Removes

- GoGuardian Chrome extensions
- GoGuardian policy files
- References in Chrome preferences
- Network connections to GoGuardian servers

---

## ❓ FAQ

See [FAQ.md](FAQ.md) for answers to common questions about using Blackout without developer mode.

---

## 🌑 Philosophy

> *They can't control what they can't see.*  
Blackout doesn't just remove surveillance. It returns power to the user.

---

## ✒️ Credits

**Developed by Vanta**  
Find me in the void. Or don't.

---

## 🖤 License

MIT.  
But ask yourself: *Would they license your freedom?*