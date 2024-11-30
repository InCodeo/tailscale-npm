#!/bin/sh

if [ ! -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "[Tailscale] Starting service..."
    
    # Ensure directories exist
    mkdir -p /var/run/tailscale
    mkdir -p /var/lib/tailscale
    
    # Start tailscaled in the foreground (important for s6)
    exec /usr/sbin/tailscaled \
        --state=/var/lib/tailscale/tailscaled.state \
        --socket=/var/run/tailscale/tailscaled.sock \
        --verbose=1
else
    echo "[Tailscale] No auth key provided, service not starting"
    exit 0
fi