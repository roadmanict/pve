server {
	listen 80;
	listen [::]:80;

	server_name *.svc.gweggemans.nl;

	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl;
	server_name	pfsense.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	proxy_redirect off;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";

		proxy_pass	https://10.6.11.254:443;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
	}
}

server {
	listen 443 ssl;
	server_name	unify.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	proxy_redirect off;

	location / {
		proxy_pass https://10.6.11.115:8443;
		proxy_ssl_verify off;
		proxy_ssl_session_reuse on;
		proxy_buffering off;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		## Specific to Unifi Controller
		proxy_hide_header Authorization;
		proxy_set_header Referer '';
		proxy_set_header Origin '';
	}

	location /inform {
		proxy_pass https://10.6.11.115:8080;
		proxy_ssl_verify off;
		proxy_ssl_session_reuse on;
		proxy_buffering off;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		## Specific to Unifi Controller
		proxy_hide_header Authorization;
		proxy_set_header Referer '';
		proxy_set_header Origin '';
	}

	location /wss {
		proxy_pass https://10.6.11.115:8443;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		## Specific to Unifi Controller
		proxy_set_header Origin '';
		proxy_buffering off;
		proxy_hide_header Authorization;
		proxy_set_header Referer '';
	}
}

server {
	listen 443 ssl;
	server_name	dashy.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;
	
	location / {
		proxy_pass http://10.100.100.102:4000;
	}
}


server {
	listen 443 ssl;
	server_name	home-assistant.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;
	
	location / {
		proxy_pass http://10.6.11.103:8123;
		proxy_set_header Host $host;
		proxy_redirect http:// https://;
		proxy_http_version 1.1;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
	}

	location /api/websocket {
		proxy_pass http://10.6.11.103:8123/api/websocket;
		proxy_set_header Host $host;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
	}
}

server {
	listen 443 ssl;
	server_name	pve.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	proxy_redirect off;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";

		proxy_pass	https://10.6.11.99:8006;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
	}
}

server {
	listen 443 ssl;
	server_name	pbs.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	proxy_redirect off;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";

		proxy_pass	https://10.100.100.106:8007;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
	}
}

server {
	listen 443 ssl;
	server_name	adguardhome.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	location / {
		proxy_pass http://10.100.100.205:80;
	}
}

server {
	listen 443 ssl;
	server_name	nas.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	location / {
		proxy_pass http://10.100.100.111:80;
		proxy_http_version 1.1;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Forwarded-Server $host;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $http_connection;
	}
}

upstream svc-docker-registry {
	server svc-docker-registry:5000;
}

server {
	listen 443 ssl;
	server_name registry.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_pass http://svc-docker-registry;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "Upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}

server {
	listen 443 ssl;
	server_name	nomnomz.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;
	
	location / {
		proxy_pass http://10.100.100.21:8081;

		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_set_header Host $http_host;
	}
}

upstream diskstation {
	server diskstation.lan.gweggemans.nl:5001;
}

server {
	listen 443 ssl;
	server_name diskstation.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	https://diskstation;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream deluge {
	server arr-stack.lan.gweggemans.nl:8112;
}

server {
	listen 443 ssl;
	server_name deluge.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	http://deluge;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream prowlarr {
	server arr-stack.lan.gweggemans.nl:9696;
}

server {
	listen 443 ssl;
	server_name prowlarr.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	http://prowlarr;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream sonarr {
	server arr-stack.lan.gweggemans.nl:8989;
}

server {
	listen 443 ssl;
	server_name sonarr.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	http://sonarr;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream radarr {
	server arr-stack.lan.gweggemans.nl:7878;
}

server {
	listen 443 ssl;
	server_name radarr.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	http://radarr;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream bazarr {
	server arr-stack.lan.gweggemans.nl:6767;
}

server {
	listen 443 ssl;
	server_name bazarr.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	http://bazarr;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream jellyfin {
	server jellyfin.lan.gweggemans.nl:7878;
}

server {
	listen 443 ssl;
	server_name jellyfin.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_pass	http://jellyfin;
		proxy_buffering off;
		client_max_body_size 0;
		proxy_connect_timeout 3600s;
		proxy_read_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
    }
}

upstream authentik {
    server docker-1.lan.gweggemans.nl:9443;
    # Improve performance by keeping some connections alive.
    keepalive 10;
}

# Upgrade WebSocket if requested, otherwise use keepalive
map $http_upgrade $connection_upgrade_keepalive {
    default upgrade;
    ''      '';
}

server {
    # HTTPS server config
    listen 443 ssl http2;
    server_name authentik.svc.gweggemans.nl;

	ssl_certificate /etc/letsencrypt/live/svc.gweggemans.nl/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.gweggemans.nl/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.gweggemans.nl/chain.pem;

    # Proxy site
    location / {
        proxy_pass https://authentik;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade_keepalive;
    }
}
