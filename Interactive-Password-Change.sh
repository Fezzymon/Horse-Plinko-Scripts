#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Use sudo."
  exit 1
fi

# Prompt for the username
read -p "Enter the username: " USERNAME

# Validate that the username is not empty
if [ -z "$USERNAME" ]; then
  echo "Error: Username cannot be empty."
  exit 1
fi

# Prompt for the new password
read -s -p "Enter new password for user '$USERNAME': " NEW_PASSWORD
echo

# Prompt for password confirmation
read -s -p "Confirm new password: " CONFIRM_PASSWORD
echo

# Validate password match
if [ "$NEW_PASSWORD" != "$CONFIRM_PASSWORD" ]; then
  echo "❌ Passwords do not match. Aborting."
  exit 1
fi

# Change the password using chpasswd
echo "$USERNAME:$NEW_PASSWORD" | chpasswd

# Check if the password change was successful
if [ $? -eq 0 ]; then
  echo "✅ Password for user '$USERNAME' has been successfully changed."
else
  echo "❌ Failed to change password for user '$USERNAME'."
fi
