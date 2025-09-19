admins = { "acidvegas@xmpp.supernets.org" }

plugin_paths = { "/usr/local/lib/prosody/modules" }

pidfile = "/run/prosody/prosody.pid";

limits = {
    c2s   = { rate = "3kb/s";  burst = "2s"; };
    s2sin = { rate = "10kb/s"; burst = "5s"; };
}

log = "*syslog"

VirtualHost "xmpp.supernets.org"
    modules_enabled = {
        "admin_adhoc";             -- https://prosody.im/doc/modules/mod_admin_adhoc
        "announce";                -- https://prosody.im/doc/modules/mod_announce
        "blocklist";               -- https://prosody.im/doc/modules/mod_blocklist
        "carbons";                 -- https://prosody.im/doc/modules/mod_carbons
        "cloud_notify";            -- https://prosody.im/doc/modules/mod_cloud_notify
        "csi_simple";              -- https://prosody.im/doc/modules/mod_csi_simple
        "dialback";                -- https://prosody.im/doc/modules/mod_dialback
        "disco";                   -- https://prosody.im/doc/modules/mod_disco
        "limits";                  -- https://prosody.im/doc/modules/mod_limits
        "mam";                     -- https://prosody.im/doc/modules/mod_mam
        "muc_mam";                 -- https://prosody.im/doc/modules/mod_muc_mam
        "offline";                 -- https://prosody.im/doc/modules/mod_offline
        "pep";                     -- https://prosody.im/doc/modules/mod_pep
        "ping";                    -- https://prosody.im/doc/modules/mod_ping
        "posix";                   -- https://prosody.im/doc/modules/mod_posix
        "private";                 -- https://prosody.im/doc/modules/mod_private
        "register";                -- https://prosody.im/doc/modules/mod_register
        "register_limits",         -- https://prosody.im/doc/modules/mod_register_limits
        "roster";                  -- https://prosody.im/doc/modules/mod_roster
        "saslauth";                -- https://prosody.im/doc/modules/mod_saslauth
        "smacks";                  -- https://prosody.im/doc/modules/mod_smacks
        "tls";                     -- https://prosody.im/doc/modules/mod_tls
        "user_account_management"; -- https://prosody.im/doc/modules/mod_user_account_management
        "watchregistrations";      -- https://prosody.im/doc/modules/mod_watchregistrations
        "omemo_all_access";        -- https://modules.prosody.im/mod_omemo_all_access
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
