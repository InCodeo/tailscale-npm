# Use the official NPM image as base
FROM jc21/nginx-proxy-manager:latest

# Install Tailscale and required dependencies
RUN mkdir -p /var/run/tailscale /etc/cont-init.d && \
    apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    iptables && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy init scripts
COPY tailscale-init.sh /etc/cont-init.d/tailscale
RUN chmod +x /etc/cont-init.d/tailscale

# Ensure Tailscale can access required devices
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun