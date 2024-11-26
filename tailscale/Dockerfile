FROM alpine:latest

# Create /dev/net/tun for Tailscale
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun

# Install Tailscale and necessary packages
RUN apk add --no-cache tailscale supervisor curl iptables ip6tables

# Ensure the supervisor log directory exists
RUN mkdir -p /var/log/supervisor

# Copy configurations
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]