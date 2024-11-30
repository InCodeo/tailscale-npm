#!/bin/sh

# Check if the Tailscale auth key is provided
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "TAILSCALE_AUTH_KEY environment variable is not set. Exiting."
    exit 1
fi

# Start supervisord to manage tailscale and nginx
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf