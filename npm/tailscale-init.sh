#!/usr/bin/with-contenv bash

# Ensure required directories exist
mkdir -p /var/run/tailscale
mkdir -p /var/lib/tailscale

# Start tailscaled if auth key is provided
if [ ! -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "Starting Tailscale daemon..."
    tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    
    # Wait for daemon to start
    sleep 5
    
    echo "Authenticating Tailscale..."
    tailscale up \
        --authkey="$TAILSCALE_AUTH_KEY" \
        --hostname="npm-proxy" \
        --accept-routes \
        --accept-dns=false
    
    # Wait for Tailscale to be ready
    echo "Waiting for Tailscale connection..."
    until tailscale status | grep -q "Connected"; do
        sleep 1
    done
    
    echo "Tailscale connection established"
fi

# Keep the script running to maintain tailscaled
exec tail -f /dev/null