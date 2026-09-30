#!/bin/sh
# certbot deploy hook: copy a renewed cert into the prosody container config and restart it
set -e
dst=/home/supernets/xmpp/etc/certs/$(basename "$RENEWED_LINEAGE")
mkdir -p "$dst"
cp -L "$RENEWED_LINEAGE/fullchain.pem" "$RENEWED_LINEAGE/privkey.pem" "$dst/"
docker restart xmpp
