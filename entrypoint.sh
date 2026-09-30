#!/bin/sh
set -e

mkdir -p /run/prosody
chown -R prosody:prosody /run/prosody /var/lib/prosody 2>/dev/null || true

# Normalize cert ownership so the unprivileged prosody user can read the keys
# (data + certs arrive from the old box with a different numeric uid).
if [ -d /etc/prosody/certs ]; then
  chown -R prosody:prosody /etc/prosody/certs 2>/dev/null || true
  find /etc/prosody/certs -name 'privkey.pem' -exec chmod 640 {} \; 2>/dev/null || true
  find /etc/prosody/certs -name 'fullchain.pem' -exec chmod 644 {} \; 2>/dev/null || true
fi

exec runuser -u prosody -- prosody -F --config /etc/prosody/prosody.cfg.lua
