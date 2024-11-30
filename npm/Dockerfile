FROM jc21/nginx-proxy-manager:latest

# Install Tailscale and required dependencies
RUN mkdir -p /var/run/tailscale \
    /package/admin/s6-overlay-3.1.5.0/etc/s6-rc/scripts/cont-init.d && \
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

# Setup S6 service structure for Tailscale
RUN mkdir -p /etc/services.d/tailscale

# Copy service definition files
COPY services.d/tailscale/run /etc/services.d/tailscale/run
COPY services.d/tailscale/finish /etc/services.d/tailscale/finish

# Set correct permissions
RUN chmod +x /etc/services.d/tailscale/run /etc/services.d/tailscale/finish

# Setup Tailscale device
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun

# Copy authentication script
COPY tailscale-auth.sh /package/admin/s6-overlay-3.1.5.0/etc/s6-rc/scripts/cont-init.d/tailscale
RUN chmod +x /package/admin/s6-overlay-3.1.5.0/etc/s6-rc/scripts/cont-init.d/tailscale