#!/bin/bash

read -p "Enter the domain name (e.g., underserved.org): " DOMAIN
read -p "Enter the Common Name (CN, usually same as above): " CN
read -p "Enter the Organisation (O): " ORGANIZATION
read -p "Enter the Organisational Unit (OU): " ORG_UNIT

echo ""
echo "You entered:"
echo "  Domain Name: $DOMAIN"
echo "  Common Name: $CN"
echo "  Organisation: $ORGANIZATION"
echo "  Organisational Unit: $ORG_UNIT"
read -p "Press Enter to continue..."

echo "Checking if Certbot is installed..."
CERTBOT="$(command -v certbot)"
if [ -z "$CERTBOT" ]; then
  echo "Certbot is not installed. Installing Certbot..."
  sudo apt update && sudo apt install -y certbot
  CERTBOT="$(command -v certbot)"
fi

echo ""
echo "Warning: All existing SSL certs will be removed from the server."
read -p "Press Enter to continue or Ctrl+C to cancel..."

sudo $CERTBOT delete

sudo $CERTBOT certonly \
  --manual \
  --preferred-challenges dns \
  --server https://acme-v02.api.letsencrypt.org/directory \
  -d "${DOMAIN}" \
  -d "*.${DOMAIN}"

if [ $? -eq 0 ]; then
  echo -e "\n✅ Certificate successfully generated for $DOMAIN!"
  echo "Certificates are saved in /etc/letsencrypt/live/$DOMAIN/"

  TARGET_DIR="nginx/ssl"
  sudo mkdir -p "$TARGET_DIR"

  sudo cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$TARGET_DIR/"
  sudo cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$TARGET_DIR/"

  echo "Updating nginx config files..."
  find nginx/sites-enabled -type f -name '*.conf' \
    -exec sudo sed -i 's|nginx-selfsigned.crt|fullchain.pem|g' {} \;
  find nginx/sites-enabled -type f -name '*.conf' \
    -exec sudo sed -i 's|nginx-selfsigned.key|privkey.pem|g' {} \;

  echo -e "\n✅ Certificates have been copied to $TARGET_DIR:"
  echo "  - Full Chain: $TARGET_DIR/fullchain.pem"
  echo "  - Private Key: $TARGET_DIR/privkey.pem"
else
  echo "❌ Error: Certificate generation failed." >&2
  exit 1
fi

echo ""
echo "Restarting Docker services..."
docker compose down
docker compose up -d --build

echo ""
echo "SSL Certificate setup complete!"
echo "To complete this process, please reboot the server:"
sudo reboot
