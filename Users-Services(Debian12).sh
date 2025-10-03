#!/bin/bash

# lists non-default users, startup processes, and services

echo "--- Non-Default Users ---"
getent passwd | awk -F: '$3 > 1000 && $3 != 0' | cut -d: -f1

echo ""
echo "--- Startup Services/Processes (Potential Non-Defaults) ---"
#Get all services
systemd-analyze --user | grep "Loaded" | awk '{print $3}' | grep '.service$'

echo ""
echo "--- Processes Running as Non-Default Users ---"
ps -eo user,pid,command | awk '$1 !~ /root|bin|daemon|sys|_|-|nobody|nginx|apache|mysql|_httpd|www-data/'

echo ""
echo "--- End of Report ---"
