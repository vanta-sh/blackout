#!/bin/bash
# BLACKOUT - GoGuardian Removal Tool
# Developer: Vanta
# Version: 1.0.0

# Default target is root (/)
TARGET_ROOT="/"

# Process command line arguments
for arg in "$@"; do
  case $arg in
    --target=*)
      TARGET_ROOT="${arg#*=}"
      echo "Using target root directory: $TARGET_ROOT"
      shift
      ;;
    --help)
      echo "Usage: ./blackout.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --target=/path    Specify target root directory (for USB recovery method)"
      echo "  --help            Show this help message"
      exit 0
      ;;
  esac
done

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BOLD}${BLUE}"
echo "██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗   ██╗████████╗"
echo "██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝"
echo "██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║   ██║   ██║   "
echo "██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║   ██║   ██║   "
echo "██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚██████╔╝   ██║   "
echo "╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   "
echo -e "${NC}"
echo -e "${BOLD}Surveillance ends here.${NC}"
echo -e "Developed by ${BOLD}Vanta${NC}"
echo ""
echo -e "${YELLOW}DISCLAIMER: For educational purposes only. Use at your own risk.${NC}"
echo ""

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[!] ERROR: This script must be run as root${NC}"
    echo "Try: sudo -i"
    echo "Then navigate to where this script is and run it again."
    exit 1
fi

# Function to check if we're on a ChromeOS device
check_chromeos() {
    if [ "$TARGET_ROOT" = "/" ]; then
        # If running directly on the system
        if [ ! -f /etc/lsb-release ] || ! grep -q "Chrome OS" /etc/lsb-release; then
            echo -e "${RED}[!] ERROR: This script is designed to run on Chrome OS only.${NC}"
            exit 1
        fi
        echo -e "${GREEN}[✓] Confirmed running on Chrome OS${NC}"
    else
        # If targeting a mounted filesystem
        if [ ! -f "$TARGET_ROOT/etc/lsb-release" ] || ! grep -q "Chrome OS" "$TARGET_ROOT/etc/lsb-release"; then
            echo -e "${YELLOW}[!] WARNING: Target filesystem might not be Chrome OS.${NC}"
            echo -e "Continue anyway? (y/n)"
            read -r answer
            if [[ ! "$answer" =~ ^[Yy]$ ]]; then
                exit 1
            fi
        else
            echo -e "${GREEN}[✓] Confirmed target is a Chrome OS filesystem${NC}"
        fi
    fi
}

# Known GoGuardian extension IDs
GG_EXTENSIONS=(
    "haldlgldplgnggkjaafhelgiaglafanh" # GoGuardian for Teachers
    "espgjbcpfoodjihlfbeqicoemghgmgff" # GoGuardian for Students  
    "jaoebcikabjppaclpgbodmmnfjihdngk" # GoGuardian for Admins
    "ihhbcimcpkjfhbichh" # Another possible GoGuardian extension
)

# Known GoGuardian domains for hosts file blocking
GG_DOMAINS=(
    "goguardian.com"
    "gogoslovakia.com"
    "goguardianleader.com"
    "goguardian.net"
    "api.goguardian.com"
    "firestore.goguardian.com"
    "x3-report.goguardian.com"
    "countvoncount.goguardian.com"
    "extapi.goguardian.com"
)

# GoGuardian-related policy files and locations
GG_POLICIES=(
    "/etc/opt/chrome/policies/managed/policy.json"
    "/etc/chromium/policies/managed/policy.json"
    "/etc/opt/chrome/policies/recommended/policy.json"
    "/var/lib/google-chrome-policy/user_policy"
)

# Function to detect and remove GoGuardian extensions
remove_extensions() {
    echo -e "${BLUE}[*] Scanning for GoGuardian extensions...${NC}"
    
    local found=0
    local ext_dir="${TARGET_ROOT}/home/chronos/user/Extensions"
    local chrome_dir="${TARGET_ROOT}/opt/google/chrome/extensions"
    
    # Check if the extension directories exist
    if [ ! -d "$ext_dir" ] && [ ! -d "$chrome_dir" ]; then
        echo -e "${YELLOW}[!] Chrome extension directories not found.${NC}"
        return
    fi
    
    # Check user extensions
    if [ -d "$ext_dir" ]; then
        for ext_id in "${GG_EXTENSIONS[@]}"; do
            if [ -d "$ext_dir/$ext_id" ]; then
                echo -e "${GREEN}[+] Found GoGuardian extension: $ext_id${NC}"
                echo -e "${YELLOW}[*] Removing extension data...${NC}"
                rm -rf "$ext_dir/$ext_id"
                echo -e "${GREEN}[✓] Removed extension from user profile${NC}"
                found=1
            fi
        done
    fi
    
    # Check system-wide extensions
    if [ -d "$chrome_dir" ]; then
        for ext_id in "${GG_EXTENSIONS[@]}"; do
            if [ -f "$chrome_dir/$ext_id.json" ]; then
                echo -e "${GREEN}[+] Found system-wide GoGuardian extension: $ext_id${NC}"
                echo -e "${YELLOW}[*] Removing system extension...${NC}"
                rm -f "$chrome_dir/$ext_id.json"
                echo -e "${GREEN}[✓] Removed system extension${NC}"
                found=1
            fi
        done
    fi
    
    # Check Chrome preferences for extension references
    local pref_file="${TARGET_ROOT}/home/chronos/user/Default/Preferences"
    if [ -f "$pref_file" ]; then
        local backup_file="$pref_file.blackout_backup"
        cp "$pref_file" "$backup_file"
        
        echo -e "${YELLOW}[*] Checking Chrome preferences file...${NC}"
        for ext_id in "${GG_EXTENSIONS[@]}"; do
            if grep -q "$ext_id" "$pref_file"; then
                echo -e "${GREEN}[+] Found reference to GoGuardian in preferences: $ext_id${NC}"
                # This is a simplistic approach - ideally we'd use jq to properly modify the JSON
                sed -i "s/\"$ext_id\":[^}]*}//g" "$pref_file"
                echo -e "${GREEN}[✓] Removed extension reference from preferences${NC}"
                found=1
            fi
        done
    fi
    
    if [ $found -eq 0 ]; then
        echo -e "${YELLOW}[!] No GoGuardian extensions found.${NC}"
    else
        echo -e "${GREEN}[✓] Finished removing extensions${NC}"
    fi
}

# Function to block GoGuardian domains in hosts file
block_domains() {
    echo -e "${BLUE}[*] Setting up domain blocking...${NC}"
    
    local hosts_file="${TARGET_ROOT}/etc/hosts"
    
    # Check if we can write to hosts file
    if [ ! -w "$hosts_file" ]; then
        # Try to make it writable
        if [ "$TARGET_ROOT" = "/" ]; then
            mount -o remount,rw /
        fi
        
        if [ ! -w "$hosts_file" ]; then
            echo -e "${YELLOW}[!] Cannot write to hosts file directly.${NC}"
            echo -e "Attempting alternative method..."
            
            # Create a new hosts file and try to replace the old one
            local new_hosts="/tmp/blackout_hosts"
            cp "$hosts_file" "$new_hosts"
            
            # Add comment marker
            echo "# BLACKOUT - GoGuardian domain blocking" >> "$new_hosts"
            
            # Add each domain to the new hosts file
            for domain in "${GG_DOMAINS[@]}"; do
                echo -e "${YELLOW}[*] Preparing to block domain: $domain${NC}"
                echo "127.0.0.1 $domain" >> "$new_hosts"
                echo "127.0.0.1 www.$domain" >> "$new_hosts"
                echo "127.0.0.1 api.$domain" >> "$new_hosts"
                echo "127.0.0.1 accounts.$domain" >> "$new_hosts"
                echo "127.0.0.1 services.$domain" >> "$new_hosts"
            done
            
            # Try to replace the original hosts file
            if cp "$new_hosts" "$hosts_file" 2>/dev/null; then
                echo -e "${GREEN}[✓] Domain blocking configured${NC}"
            else
                echo -e "${RED}[!] Could not update hosts file.${NC}"
                echo -e "${YELLOW}[*] Manual hosts file created at $new_hosts${NC}"
                echo -e "${YELLOW}[*] You'll need to manually copy it to $hosts_file${NC}"
            fi
            
            return
        fi
    fi
    
    # If we got here, we can write to the hosts file
    # Backup hosts file
    cp "$hosts_file" "$hosts_file.blackout_backup"
    
    # Add comment marker
    echo "# BLACKOUT - GoGuardian domain blocking" >> "$hosts_file"
    
    # Add each domain to hosts file
    for domain in "${GG_DOMAINS[@]}"; do
        echo -e "${YELLOW}[*] Blocking domain: $domain${NC}"
        # Block both the domain and www subdomain
        echo "127.0.0.1 $domain" >> "$hosts_file"
        echo "127.0.0.1 www.$domain" >> "$hosts_file"
        # Block various subdomains that GoGuardian might use
        echo "127.0.0.1 api.$domain" >> "$hosts_file"
        echo "127.0.0.1 accounts.$domain" >> "$hosts_file"
        echo "127.0.0.1 services.$domain" >> "$hosts_file"
    done
    
    echo -e "${GREEN}[✓] Domain blocking complete${NC}"
}

# Function to remove GoGuardian policies
remove_policies() {
    echo -e "${BLUE}[*] Checking for GoGuardian policies...${NC}"
    
    local found=0
    
    for policy_path in "${GG_POLICIES[@]}"; do
        local policy_file="${TARGET_ROOT}${policy_path}"
        if [ -f "$policy_file" ]; then
            echo -e "${GREEN}[+] Found policy file: $policy_file${NC}"
            
            # Make backup
            cp "$policy_file" "$policy_file.blackout_backup"
            
            # Check if file mentions GoGuardian
            if grep -q -i "goguardian\|guardian\|monitoring\|surveillance" "$policy_file"; then
                echo -e "${YELLOW}[*] Policy file contains GoGuardian references${NC}"
                # Attempt to modify the policy file
                if [[ "$policy_file" == *".json" ]]; then
                    # For JSON files, we can try to modify them while preserving structure
                    # This is a simplistic approach - ideally we'd use jq
                    sed -i 's/"goguardian[^"]*":[^,}]*[,}]/"/g' "$policy_file"
                    sed -i 's/"guardian[^"]*":[^,}]*[,}]/"/g' "$policy_file"
                    echo -e "${GREEN}[✓] Modified policy file to remove GoGuardian entries${NC}"
                else
                    # For non-JSON files, rename them to disable them
                    mv "$policy_file" "$policy_file.blackout_disabled"
                    echo -e "${GREEN}[✓] Disabled policy file${NC}"
                fi
                found=1
            fi
        fi
    done
    
    if [ $found -eq 0 ]; then
        echo -e "${YELLOW}[!] No GoGuardian policy files found.${NC}"
    else
        echo -e "${GREEN}[✓] Finished processing policy files${NC}"
    fi
}

# Function to disable Chrome sync temporarily (can prevent policy reapplication)
disable_chrome_sync() {
    echo -e "${BLUE}[*] Disabling Chrome sync temporarily...${NC}"
    
    local pref_file="${TARGET_ROOT}/home/chronos/user/Default/Preferences"
    if [ -f "$pref_file" ]; then
        # Backup preferences file
        cp "$pref_file" "$pref_file.sync_backup"
        
        # Modify sync settings
        # This is a simplistic approach
        sed -i 's/"sync_enabled":true/"sync_enabled":false/g' "$pref_file"
        
        echo -e "${GREEN}[✓] Chrome sync disabled${NC}"
    else
        echo -e "${YELLOW}[!] Chrome preferences file not found. Cannot disable sync.${NC}"
    fi
}

# Function to create a startup script that applies these changes on boot
create_startup_script() {
    echo -e "${BLUE}[*] Creating persistence script...${NC}"
    
    # Create directory for our script if it doesn't exist
    mkdir -p "${TARGET_ROOT}/usr/local/bin"
    
    # Create the startup script
    cat > "${TARGET_ROOT}/usr/local/bin/blackout_persist.sh" << 'EOL'
#!/bin/bash
# BLACKOUT Persistence Script
# This runs at startup to maintain GoGuardian blocking

# Wait for network to be up
sleep 30

# Block domains in hosts file
if [ -f /etc/hosts ]; then
    # Check if our blocks are still there
    if ! grep -q "BLACKOUT" /etc/hosts; then
        echo "# BLACKOUT - GoGuardian domain blocking" >> /etc/hosts
        # Add blocking for main domains
        for domain in goguardian.com gogoslovakia.com goguardianleader.com goguardian.net; do
            echo "127.0.0.1 $domain" >> /etc/hosts
            echo "127.0.0.1 www.$domain" >> /etc/hosts
        done
    fi
fi

# Check for GoGuardian extensions and remove them
for ext_path in /home/chronos/user/Extensions/*/ /opt/google/chrome/extensions/*.json; do
    # Look for known GoGuardian extensions
    for gg_ext in haldlgldplgnggkjaafhelgiaglafanh espgjbcpfoodjihlfbeqicoemghgmgff jaoebcikabjppaclpgbodmmnfjihdngk; do
        if [[ "$ext_path" == *"$gg_ext"* ]]; then
            rm -rf "$ext_path"
        fi
    done
done

exit 0
EOL

    # Make it executable
    chmod +x "${TARGET_ROOT}/usr/local/bin/blackout_persist.sh"
    
    # Create a systemd service to run it at startup
    mkdir -p "${TARGET_ROOT}/etc/systemd/system"
    cat > "${TARGET_ROOT}/etc/systemd/system/blackout.service" << 'EOL'
[Unit]
Description=Blackout GoGuardian Blocker
After=network.target

[Service]
ExecStart=/usr/local/bin/blackout_persist.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
EOL

    # Enable the service to start at boot (only if running on live system)
    if [ "$TARGET_ROOT" = "/" ]; then
        systemctl enable blackout.service
    else
        echo -e "${YELLOW}[!] Not running on the live system. Service will be enabled on next boot.${NC}"
        echo -e "${YELLOW}[!] Create symlink manually: ln -sf ${TARGET_ROOT}/etc/systemd/system/blackout.service ${TARGET_ROOT}/etc/systemd/system/multi-user.target.wants/blackout.service${NC}"
        mkdir -p "${TARGET_ROOT}/etc/systemd/system/multi-user.target.wants"
        ln -sf "${TARGET_ROOT}/etc/systemd/system/blackout.service" "${TARGET_ROOT}/etc/systemd/system/multi-user.target.wants/blackout.service"
    fi
    
    echo -e "${GREEN}[✓] Persistence service created and enabled${NC}"
}

# Main execution flow
main() {
    check_chromeos
    
    echo -e "${BOLD}${BLUE}[*] Starting GoGuardian removal process...${NC}"
    
    # Remount filesystem as read-write if possible
    if [ "$TARGET_ROOT" = "/" ]; then
        echo -e "${YELLOW}[*] Attempting to remount filesystem as read-write...${NC}"
        mount -o remount,rw /
    else
        echo -e "${YELLOW}[*] Working on mounted filesystem at $TARGET_ROOT${NC}"
    fi
    
    # Execute the removal functions
    remove_extensions
    block_domains
    remove_policies
    disable_chrome_sync
    create_startup_script
    
    echo -e "${BOLD}${GREEN}[✓] BLACKOUT COMPLETE${NC}"
    echo ""
    
    if [ "$TARGET_ROOT" = "/" ]; then
        echo -e "${YELLOW}System needs to be restarted to apply all changes.${NC}"
        echo -e "Would you like to restart now? (y/n)"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Restarting system...${NC}"
            reboot
        else
            echo -e "${YELLOW}Please restart manually when convenient.${NC}"
        fi
    else
        echo -e "${YELLOW}Filesystem modifications complete. You can now unmount and restart.${NC}"
    fi
}

# Run the main function
main 