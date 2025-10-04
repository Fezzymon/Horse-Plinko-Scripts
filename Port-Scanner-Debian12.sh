#!/bin/bash

# Install netcat if not already installed
if ! command -v nc &> /dev/null; then
    echo "Netcat not found. Installing..."
    sudo apt update
    sudo apt install -y netcat
    if ! command -v nc &> /dev/null; then
        echo "Failed to install netcat. Aborting."
        exit 1
    fi
fi

# Scan local machine for open ports (1–1023)
echo "=== Scanning local machine for open ports (1–1023) ==="
nc -zv localhost 1-1023 2>&1 | grep succeeded
