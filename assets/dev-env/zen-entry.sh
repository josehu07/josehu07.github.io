#!/bin/bash
set -e -u


# Optional arguments:
#   - $1: host users UID
#   - $2: host users GID
# These are for setting up the UID:GID of the user in container to get rid
# of bind-mount permission issues.
HOST_UID=${1:-1001}
HOST_GID=${2:-1001}

# Change the UID and GID of the user
echo "Setting UID:GID of ${MYUSER}..."
usermod -u ${HOST_UID} ${MYUSER}
groupmod -g ${HOST_GID} ${MYUSER}


# Start SSH servere and keep running
echo "Starting SSH server on port 22..."
/usr/sbin/sshd -D
