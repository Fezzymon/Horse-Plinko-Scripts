#!/bin/bash

# Prompt user for IP address
read -p "Enter the IP address to block: " IP

# Validate IP format
if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Valid IP address: $IP"
else
    echo "Invalid IP address format."
    exit 1
fi

# Check if nftables is installed, install if not
if ! command -v nft &> /dev/null; then
    echo "nftables not found. Installing..."
    sudo apt update
    sudo apt install -y nftables
fi

# Add nftables rule to block the IP
sudo nft -f <<EOF
table ip filter {
    chain input {
        type filter hook input priority 0;
        policy accept;
        ip saddr $IP drop;
    }
}
EOF

# Confirm the rule was added
echo "Blocked IP: $IP from accessing any ports on this system."
echo "To unblock, run: sudo nft -f <<EOF
table ip filter {
    chain input {
        type filter hook input priority 0;
        policy accept;
        ip saddr $IP drop;
    }
}
EOF
