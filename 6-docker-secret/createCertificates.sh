#!/bin/sh
docker-machine ssh docker-security-1 'openssl genrsa -out "site.key" 4096'
docker-machine ssh docker-security-1 'openssl req -new -key "site.key" -out "site.csr" -sha256 -subj "/C=SE/L=Stockholm/O=Omegapoint/CN=localhost"'
docker-machine ssh docker-security-1 'cat > cert.ext' < cert.ext
docker-machine ssh docker-security-1 'sudo openssl x509 -req -days 7 -in "site.csr" -sha256 -CA "/var/lib/boot2docker/tls/ca.pem" -CAkey "/var/lib/boot2docker/tls/cakey.pem" -CAcreateserial -out "site.crt" -extfile "cert.ext" -extensions server'
docker-machine ssh docker-security-1 'sudo cp /var/lib/boot2docker/tls/ca.pem .'
docker-machine ssh docker-security-1 'cat site.crt' > site.crt
docker-machine ssh docker-security-1 'cat site.key' > site.key
docker-machine ssh docker-security-1 'rm site.*'
docker-machine ssh docker-security-1 'rm cert.ext'