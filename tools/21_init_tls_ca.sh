#!/bin/bash

set -x
cd ..

# Create directories
mkdir -p ca/tls-ca/private ca/tls-ca/db crl certs
chmod 700 ca/tls-ca/private

# Create database
cp /dev/null ca/tls-ca/db/tls-ca.db
cp /dev/null ca/tls-ca/db/tls-ca.db.attr
echo 01 > ca/tls-ca/db/tls-ca.crt.srl
echo 01 > ca/tls-ca/db/tls-ca.crl.srl

# Create CA request
openssl req -new \
    -config etc/tls-ca.conf \
    -out ca/tls-ca.csr \
    -keyout ca/tls-ca/private/tls-ca.key

# Create CA certificate
openssl ca \
    -config etc/root-ca.conf \
    -in ca/tls-ca.csr \
    -out ca/tls-ca.crt \
    -extensions signing_ca_ext

# Create initial CRL
openssl ca -gencrl \
    -config etc/tls-ca.conf \
    -out crl/tls-ca.crl

# Create PEM bundle
cat ca/tls-ca.crt ca/root-ca.crt > \
    ca/tls-ca-chain.pem
