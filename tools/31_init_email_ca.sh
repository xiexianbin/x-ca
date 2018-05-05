#!/bin/bash

set -x
cd ..

# Create directories
mkdir -p ca/email-ca/private ca/email-ca/db crl certs
chmod 700 ca/email-ca/private

# Create database
cp /dev/null ca/email-ca/db/email-ca.db
cp /dev/null ca/email-ca/db/email-ca.db.attr
echo 01 > ca/email-ca/db/email-ca.crt.srl
echo 01 > ca/email-ca/db/email-ca.crl.srl

# Create CA request
openssl req -new \
    -config etc/email-ca.conf \
    -out ca/email-ca.csr \
    -keyout ca/email-ca/private/email-ca.key

# Create CA certificate
openssl ca \
    -config etc/root-ca.conf \
    -in ca/email-ca.csr \
    -out ca/email-ca.crt \
    -extensions signing_ca_ext

# Create initial CRL

openssl ca -gencrl \
    -config etc/email-ca.conf \
    -out crl/email-ca.crl

# Create PEM bundle
cat ca/email-ca.crt ca/root-ca.crt > \
    ca/email-ca-chain.pem
