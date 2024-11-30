#!/command/with-contenv bash

# Ensure required directories exist
mkdir -p /var/run/tailscale
mkdir -p /var/lib/tailscale

# Start tailscaled if auth key is provided
if [ ! -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "[Tailscale] Starting Tailscale daemon..."
    tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    
    # Wait for daemon to start
    sleep 5
    
    echo "[Tailscale] Authenticating with Tailscale..."
    tailscale up \
        --authkey="$TAILSCALE_AUTH_KEY" \
        --hostname="npm-proxy" \
        --accept-routes \
        --accept-dns=false
    
    # Wait for Tailscale to be ready
    echo "[Tailscale] Waiting for connection..."
    TRIES=0
    while ! tailscale status | grep -q "Connected" && [ $TRIES -lt 30 ]; do
        sleep 1
        TRIES=$((TRIES + 1))
    done
    
    if tailscale status | grep -q "Connected"; then
        echo "[Tailscale] Connection established"
    else
        echo "[Tailscale] Failed to establish connection within timeout"
        exit 1
    fi
fi