#!/bin/bash

ssl_key="./nginx/ssl/nginx-selfsigned.key"

# Check if SSL key already exists
if [ -f "$ssl_key" ]; then
    echo "Existing SSL Certificate found. No new SSL keys or certs will be created  ✅ "
    exit 0
fi

# Predefined values for testing
common_name="test.ngo"
organization="NGO Organisation"
controlled_domain="NGO.local"

echo "Generating a self-signed SSL certificate with test data..."

# Generate SSL certificate with hardcoded details
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout "$ssl_key" \
    -out "${ssl_key%.key}.crt" \
    -subj "/C=US/ST=State/L=City/O=${organization}/CN=${common_name}" \
    -extensions v3_ca \
    -addext "subjectAltName=DNS:${controlled_domain}"

# Check if the certificate was created successfully
if [ $? -eq 0 ]; then
    echo "Private SSL certificate successfully created at ${ssl_key%.key}.crt  ✅ "
else
    echo "❌ Failed to create the SSL certificate."
fi
