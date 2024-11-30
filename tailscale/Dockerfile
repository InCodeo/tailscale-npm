# Updated Dockerfile
FROM alpine:latest

# Create /dev/net/tun for Tailscale
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun

# Install required packages
RUN apk add --no-cache \
    tailscale \
    supervisor \
    curl \
    iptables \
    ip6tables \
    nginx

# Ensure required directories exist
RUN mkdir -p /var/log/supervisor /var/log/nginx /run/nginx

# Copy configurations
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the port that nginx will listen on
EXPOSE 3001

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]