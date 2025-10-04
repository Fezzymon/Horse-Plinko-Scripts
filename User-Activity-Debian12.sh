#!/bin/bash

#install required packages
install_packages() {
    echo "Installing required packages..."
    sudo apt update
    sudo apt install -y auditd
}

#start and enable auditd service
setup_auditd() {
    echo "Starting and enabling auditd service..."
    sudo systemctl start auditd
    sudo systemctl enable auditd
}

#check auditd is running
is_auditd_running() {
    systemctl is-active --quiet auditd
}

#add audit rule for user home directory
add_audit_rule() {
    local username="$1"
    echo "Adding audit rule to monitor changes to /home/$username..."
    sudo auditctl -w /home/$username -p war -k user_home
}

# Main

#install required packages
install_packages

#Set up auditd service
setup_auditd

#check auditd is running
if ! is_auditd_running; then
    echo "Failed to start auditd service. Aborting."
    exit 1
fi

#Prompt for username
echo "=== User Account Activity ==="
echo "Enter username:"
read username

#Check recent logins
echo "=== Recent Logins ==="
last | grep "$username"

#Check sudo command usage
echo "=== Sudo Command Usage ==="
sudo cat /var/log/auth.log | grep "sudo" | grep "$username"

#Monitor user home directory changes
add_audit_rule "$username"
echo "Audit rule added to monitor changes to /home/$username."
echo "Use 'ausearch -k user_home' to check for changes."

