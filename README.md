# Prosody

SuperNETs XMPP server. Prosody 0.12 from Debian bookworm, running in Docker with host networking so `mod_limits` sees real client IPs.

| Host                        | Purpose                                                |
| --------------------------- | ------------------------------------------------------ |
| `xmpp.supernets.org`        | Accounts *(user@xmpp.supernets.org)*                   |
| `supernets.org`             | Separate accounts *(user@supernets.org)*               |
| `muc.supernets.org`         | Chatrooms, shared by both hosts                        |
| `upload.xmpp.supernets.org` | File sharing on port 5281, 10MB per file, 7 day expiry |

## Layout

| Path                  | Description                                                                           |
| --------------------- | ------------------------------------------------------------------------------------- |
| `Dockerfile`          | Debian bookworm with `prosody`, `prosody-modules` and `lua-unbound`                   |
| `docker-compose.yml`  | Mounts `./etc` to `/etc/prosody` and `./data` to `/var/lib/prosody`                   |
| `entrypoint.sh`       | Fixes ownership of data and certs, runs Prosody in the foreground                     |
| `etc/prosody.cfg.lua` | Prosody config                                                                        |
| `certbot-deploy.sh`   | certbot deploy hook, copies renewed certs into `etc/certs` and restarts the container |

`data/` and `etc/certs/` are not tracked.

## Deploy

```bash
docker compose up -d --build
```

Ports 5222 *(c2s)*, 5269 *(s2s)* and 5281 *(file share over HTTPS)* must be open.

## Certificates

Certs are issued on the host with certbot and copied into `etc/certs/<domain>/{fullchain,privkey}.pem` by `certbot-deploy.sh`. nginx holds port 80, so the standalone authenticator needs it stopped:

```bash
certbot certonly --standalone --cert-name xmpp.supernets.org \
    -d xmpp.supernets.org -d muc.supernets.org -d upload.xmpp.supernets.org \
    --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx" \
    --deploy-hook /home/supernets/xmpp/certbot-deploy.sh
```

The `supernets.org` cert uses the same deploy hook.

## Client Setup
We use the [Profanity](https://profanity-im.github.io/) XMPP client for communication.

### Commands
```
/register acidvegas@xmpp.supernets.org
```

```
/account add acidvegas
/account default set acidvegas
/account set acidvegas clientid ""
/account set acidvegas jid acidvegas@xmpp.supernets.org
/account set acidvegas muc muc.supernets.org
/account set acidvegas nick acidvegas
/account set acidvegas port 5222
/account set acidvegas resource ""
/account set acidvegas server xmpp.supernets.org
/account set acidvegas session_alarm 2
/account set acidvegas status online
/account set acidvegas tls force
/autoconnect set acidvegas
```
```
/color on
/color own on
/connect acidvegas
/occupants color on
/omemo char 🔑
/omemo gen
/omemo log off
/omemo policy always
/omemo trustmode blind
/omemo trustmode manual
/outtype off
/privacy logging off
/privacy os off
/receipts send off
/states off
```
