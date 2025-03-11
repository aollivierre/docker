#!/bin/bash

# Create directories if they don't exist
mkdir -p ssl
mkdir -p nginx

# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ssl/key.pem \
    -out ssl/cert.pem \
    -subj "/CN=192.168.100.206" \
    -addext "subjectAltName=IP:192.168.100.206"

# Set proper permissions
chmod 600 ssl/key.pem
chmod 644 ssl/cert.pem

echo "SSL certificate generated successfully!"
