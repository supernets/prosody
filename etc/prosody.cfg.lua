-- SuperNETs XMPP (Prosody) — migrated to super-svc, runs in Docker with host networking.
-- Host networking means Prosody sees the REAL client IP, so mod_limits works per-user.

pidfile = "/run/prosody/prosody.pid";
data_path = "/var/lib/prosody"

log = {
	{ levels = { min = "info" }, to = "console" };
}

admins = { "acidvegas@xmpp.supernets.org" }

limits = {
	c2s   = { rate = "3kb/s";  burst = "2s"; };
	s2sin = { rate = "10kb/s"; burst = "5s"; };
}

-- ===================================================================
-- Existing host: accounts unchanged (user@xmpp.supernets.org)
-- ===================================================================
VirtualHost "xmpp.supernets.org"
	modules_enabled = {
		"admin_adhoc";
		"announce";
		"blocklist";
		"carbons";
		"cloud_notify";
		"csi_simple";
		--"dialback";
		"disco";
		"limits";
		"mam";
		"offline";
		"pep";
		"ping";
		"posix";
		"private";
		"register";
		--"register_limits",
		"roster";
		"saslauth";
		"smacks";
		"tls";
		"vcard";
		"user_account_management";
		"watchregistrations";
	}

	allow_registration = true
	authentication = "internal_hashed"
	c2s_require_encryption = true
	s2s_require_encryption = true

	disco_items = {
		{ "muc.supernets.org", "MUC Rooms" },
		{ "upload.xmpp.supernets.org", "XMPP File Uploads" }
	}

	ssl = {
		certificate = "/etc/prosody/certs/xmpp.supernets.org/fullchain.pem";
		key = "/etc/prosody/certs/xmpp.supernets.org/privkey.pem";
	}

-- ===================================================================
-- New host: separate accounts (user@supernets.org)
-- Shares the same MUC + upload components.
-- ===================================================================
VirtualHost "supernets.org"
	modules_enabled = {
		"admin_adhoc";
		"announce";
		"blocklist";
		"carbons";
		"cloud_notify";
		"csi_simple";
		"disco";
		"limits";
		"mam";
		"offline";
		"pep";
		"ping";
		"posix";
		"private";
		"register";
		"roster";
		"saslauth";
		"smacks";
		"tls";
		"vcard";
		"user_account_management";
		"watchregistrations";
	}

	allow_registration = true
	authentication = "internal_hashed"
	c2s_require_encryption = true
	s2s_require_encryption = true

	disco_items = {
		{ "muc.supernets.org", "MUC Rooms" },
		{ "upload.xmpp.supernets.org", "XMPP File Uploads" }
	}

	ssl = {
		certificate = "/etc/prosody/certs/supernets.org/fullchain.pem";
		key = "/etc/prosody/certs/supernets.org/privkey.pem";
	}

Component "muc.supernets.org" "muc"
	name = "SuperNETs XMPP Chatrooms"
	modules_enabled = {
		"s2s";
		"dialback";
		"disco";
		"muc";
		"muc_mam";
		"ping";
		"tls";
		"vcard";
	}

	ssl = {
		certificate = "/etc/prosody/certs/xmpp.supernets.org/fullchain.pem";
		key = "/etc/prosody/certs/xmpp.supernets.org/privkey.pem";
	}

Component "upload.xmpp.supernets.org" "http_file_share"
	modules_enabled = {
		"http_file_share";
		"dialback";
		"s2s";
		"tls";
	}
	http_external_url = "https://upload.xmpp.supernets.org:5281/"
	http_file_share_size_limit = 10*1024*1024
	http_file_share_daily_quota = 100*1024*1024
	http_file_share_global_quota = 1024*1024*1024
	http_file_share_expires_after = 7*24*60*60
	http_file_share_safe_file_types = {"image/*","video/*","audio/*","text/plain"}
	ssl = {
		certificate = "/etc/prosody/certs/xmpp.supernets.org/fullchain.pem";
		key = "/etc/prosody/certs/xmpp.supernets.org/privkey.pem";
	}
