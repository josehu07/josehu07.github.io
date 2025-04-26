FROM ubuntu:latest
ARG MYUSER=jose

# Create a non-root user with sudo privileges, empty password
RUN apt update && apt install -y sudo
RUN useradd -s /bin/bash -m ${MYUSER} && \
    passwd -d ${MYUSER} && \
    echo "${MYUSER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${MYUSER} && \
    chmod 0440 /etc/sudoers.d/${MYUSER}

# Update apt packages
RUN apt update && apt upgrade -y

# Configure SSH server
RUN mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
    echo 'PubkeyAuthentication no' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config && \
    sed -i 's/#HostKey \/etc\/ssh\/ssh_host_/HostKey \/etc\/ssh\/ssh_host_/g' /etc/ssh/sshd_config

# Generate SSH host keys with proper permissions
RUN ssh-keygen -A && \
    chmod -R 644 /etc/ssh/ssh_host_*_key.pub && \
    chmod -R 600 /etc/ssh/ssh_host_*_key && \
    chown -R root:root /etc/ssh/ssh_host_*_key*

# Create .ssh directory for ${MYUSER} user
RUN mkdir -p /home/${MYUSER}/.ssh && \
    chmod 700 /home/${MYUSER}/.ssh && \
    chown ${MYUSER}:${MYUSER} /home/${MYUSER}/.ssh && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Copy all the user-local public keys on current build host into the image
# COPY --from=dotssh *.pub /home/${MYUSER}/.ssh/
# COPY --from=dotssh *.pem /home/${MYUSER}/.ssh/
# RUN find /home/${MYUSER}/.ssh -name "*.pub" -exec cat {} >> /home/${MYUSER}/.ssh/authorized_keys \; && \
#     find /home/${MYUSER}/.ssh -name "*.pem" -exec cat {} >> /home/${MYUSER}/.ssh/authorized_keys \; && \
#     chown -R ${MYUSER}:${MYUSER} /home/${MYUSER}/.ssh

# Copy entrypoint script
COPY zen-entry.sh /etc/ssh/zen-entry.sh
RUN chmod +x /etc/ssh/zen-entry.sh

# Expose SSH port 22
EXPOSE 22

# Set up zsh as default shell for ${MYUSER} user, and switch to it
RUN chsh -s /usr/bin/zsh ${MYUSER}
USER ${MYUSER}
WORKDIR /home/${MYUSER}

# Run complete dev environment setup script
ADD https://josehu.com/assets/dev-env/auto-setup.sh /home/${MYUSER}/.auto-setup.sh
RUN ./.auto-setup.sh -y

# Set entrypoint
ENTRYPOINT ["/etc/ssh/zen-entry.sh"]
