#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"
cd /tmp/devops-test || { echo "Failed to enter directory"; exit 1; }
touch myfile.txt || { echo "Failed to enter directory"; exit 1; }

echo "All steps completed successfully!"
ls -la /tmp/devops-test
