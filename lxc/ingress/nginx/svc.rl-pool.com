server {
	listen 80;
	listen [::]:80;

	server_name *.svc.rl-pool.com svc.rl-pool.com;

	return 301 https://$host$request_uri;
}

upstream svc-rl-pool-docker-registry {
	server svc-docker-registry:5000;
}

server {
	listen 443 ssl;
	server_name registry.svc.rl-pool.com;

	ssl_certificate /etc/letsencrypt/live/svc.rl-pool.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/svc.rl-pool.com/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/svc.rl-pool.com/chain.pem;

	client_max_body_size 0;

	location / {
		proxy_pass http://svc-rl-pool-docker-registry;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "Upgrade";
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}