#!/bin/bash
set -e

echo "Starting SSH server..."
sudo service ssh start
echo "SSH server started on port 22..."

# Keep the container running
tail -f /dev/null
