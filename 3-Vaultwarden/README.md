# Installing Vaultwarden with Docker

This guide walks through setting up Vaultwarden in a Docker container on Ubuntu Server.

## Prerequisites

- Ubuntu Server
- Docker and Docker Compose installed
- Root or sudo access

## Installation Steps

Vaultwarden requires HTTPS to function properly. We'll set up Vaultwarden with Nginx as a reverse proxy using a self-signed SSL certificate.

1. Create the Vaultwarden directory:
```bash
sudo mkdir -p /opt/vw/docker
cd /opt/vw/docker
```

2. Copy the configuration files:
```bash
sudo cp docker-compose.yml nginx/vaultwarden.conf generate-cert.sh /opt/vw/docker/
```

3. Generate SSL certificate:
```bash
sudo chmod +x generate-cert.sh
sudo ./generate-cert.sh
```

4. Trust the self-signed certificate:
   - Copy the certificate to your system's trust store:
   ```bash
   sudo cp ssl/cert.pem /usr/local/share/ca-certificates/vaultwarden.crt
   sudo update-ca-certificates
   ```
   - Import the certificate in your browser:
     * Firefox: Settings → Privacy & Security → View Certificates → Import → select ssl/cert.pem
     * Chrome/Edge: Settings → Privacy and security → Security → Manage certificates → Import → select ssl/cert.pem

5. Start Vaultwarden:
```bash
sudo docker compose up -d
```

6. Access Vaultwarden:
   - Open https://192.168.100.206 in your browser
   - Accept the self-signed certificate if prompted

## Verification Steps

1. Check if the container is running:
```bash
sudo docker ps
```
You should see the Vaultwarden container running.

2. Verify the data directory was created:
```bash
ls /opt/vw/docker/vw-data
```

3. Access Vaultwarden:
- Open your web browser
- Navigate to `https://192.168.100.206`
- You should see the Vaultwarden login page

## Configuration Details

The docker-compose.yml file configures Vaultwarden with:
- Vaultwarden server 1.29.2
- Nginx reverse proxy with HTTPS
- Automatic container restart
- WebSocket support enabled
- Data persistence through volume mount
- Web interface secured with SSL
- User registration enabled
- Admin interface configured with token

## Initial Setup

1. After starting Vaultwarden, access the admin interface:
```
https://192.168.100.206/admin
```

2. Log in with the admin token: `vaultwarden123`

3. From the admin panel, you can:
   - Monitor server status
   - Configure global settings
   - Manage users
   - View logs

4. Create your first user account:
   - Visit https://192.168.100.206
   - Click "Create Account"
   - Follow the registration process

Note: If you see certificate warnings:
1. Make sure you've imported the self-signed certificate into your browser
2. Check that the certificate is in your system's trust store
3. Verify the certificate paths in the Nginx configuration

If issues persist:
1. Verify the certificates:
```bash
openssl verify /usr/local/share/ca-certificates/vaultwarden.crt
```

2. Check Nginx logs:
```bash
sudo docker logs vaultwarden_proxy
```

3. Restart the services:
```bash
cd /opt/vw/docker
sudo docker compose down
sudo docker compose up -d
```

## Stopping Vaultwarden

If you need to stop Vaultwarden:
```bash
cd /opt/vw/docker
sudo docker compose down
```

## Updating Vaultwarden

To update to the latest version:
```bash
cd /opt/vw/docker
sudo docker compose pull
sudo docker compose up -d
```

## Troubleshooting

### SSL/Certificate Issues
If you see SSL or certificate warnings:

1. Verify both containers are running:
```bash
sudo docker ps
```

2. Check Nginx configuration and logs:
```bash
sudo docker logs vaultwarden_proxy
```

3. Verify certificate permissions:
```bash
ls -l ssl/
```

4. Check Vaultwarden logs:
```bash
sudo docker logs vaultwarden
```

Note: The self-signed certificate must be trusted by both your system and browser for Vaultwarden to work properly.
