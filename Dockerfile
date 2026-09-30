FROM debian:bookworm-slim

# Prosody 0.12.x from Debian bookworm (matches the box it was migrated from: 0.12.3-1+deb12u1)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      prosody prosody-modules lua-sec lua-expat lua-socket lua-filesystem lua-unbound ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# c2s, s2s, http_file_share (all >1024, runs unprivileged)
EXPOSE 5222 5269 5281

ENTRYPOINT ["/entrypoint.sh"]
