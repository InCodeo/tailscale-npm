#!/usr/bin/with-contenv bash

if [ ! -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "Starting Tailscale..."
    tailscaled &
    sleep 5
    tailscale up --authkey="$TAILSCALE_AUTH_KEY" --hostname="npm-proxy"
fi