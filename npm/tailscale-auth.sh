#!/command/with-contenv bash

if [ ! -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "[Tailscale] Waiting for tailscaled to start..."
    # Wait for socket to exist
    while [ ! -S /var/run/tailscale/tailscaled.sock ]; do
        sleep 1
    done
    
    echo "[Tailscale] Authenticating with Tailscale..."
    tailscale up \
        --authkey="$TAILSCALE_AUTH_KEY" \
        --hostname="npm-proxy" \
        --accept-routes \
        --accept-dns=false
    
    # Wait for connection
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