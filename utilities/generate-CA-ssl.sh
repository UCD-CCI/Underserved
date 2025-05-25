#!/bin/bash

ssl_key="./nginx/ssl/nginx-selfsigned.crt"

if [ -f $ssl_key ]
then
    echo "Existing SSL Cert found, not creating new ssl keys or certs"
else
    openssl genrsa -des3 -out CaKey.key 4096
    openssl req -x509 -new -nodes -key CaKey.key -sha256 -days 1825 -out CaKey.pem
    openssl genrsa -out ../nginx/ssl/underserved_server.key 4096
    openssl req -new -key underserved_server.key -out underserved_server.csr
    openssl x509 -req -in underserved_server.csr -CA CaKey.pem -CAkey CaKey.key \
    -CAcreateserial -out ../nginx/ssl/underserved_server.crt -days 825 -sha256 -extfile alternatives/underserved_server.ext
fi