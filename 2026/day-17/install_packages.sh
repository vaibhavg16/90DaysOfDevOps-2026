#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)."
  exit 1
fi

# Ask user for package names
echo "Enter the package names you want to install (separated by spaces):"
read -r packages

# If user entered nothing, exit
if [ -z "$packages" ]; then
  echo "No packages entered. Exiting."
  exit 0
fi

# Loop through each package entered by the user
for pkg in $packages; do
  if dpkg -s "$pkg" &> /dev/null; then
    echo "$pkg is already installed. Skipping."
  else
    echo "$pkg is not installed. Installing now..."
    apt-get install -y "$pkg"
    echo "$pkg installation complete."
  fi
done
