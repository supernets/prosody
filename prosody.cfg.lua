admins = { }

plugin_paths = { "/usr/local/lib/prosody/modules" }

pidfile = "/run/prosody/prosody.pid";

limits = {
        c2s   = { rate = "3kb/s";  burst = "2s"; };
        s2sin = { rate = "10kb/s"; burst = "5s"; };
}

log = "*syslog"

VirtualHost "xmpp.supernets.org"
        modules_enabled = {
                "carbons";
                "cloud_notify";
                "dialback";
                "disco";
                "limits";
                "mam";
                "pep";
                "ping";
                "posix";
                "register";
                "register_limits",
                "roster";
                "saslauth";
                "tls";
                "omemo_all_access";
        }

        allow_registration = true -- register
        authentication = "internal_hashed" -- register
        blacklist_on_registration_throttle_overload = true -- register_limits
        c2s_require_encryption = true
        min_seconds_between_registrations = 86400 -- register_limits
        registration_throttle_cache_size = 100 -- register_limits
        s2s_require_encryption = true

        ssl = {
                certificate = "/etc/prosody/certs/xmpp.supernets.org/fullchain.pem";
                key = "/etc/prosody/certs/xmpp.supernets.org/privkey.pem";
        }

        Component "muc.supernets.org" "muc"
                name = "SuperNETs XMPP Chatrooms"
