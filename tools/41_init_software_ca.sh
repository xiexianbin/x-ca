#!/bin/bash

set -x
cd ..

# Create directories
mkdir -p ca/software-ca/private ca/software-ca/db crl certs
chmod 700 ca/software-ca/private

# Create database
cp /dev/null ca/software-ca/db/software-ca.db
cp /dev/null ca/software-ca/db/software-ca.db.attr
echo 01 > ca/software-ca/db/software-ca.crt.srl
echo 01 > ca/software-ca/db/software-ca.crl.srl

# Create CA request
openssl req -new \
    -config etc/software-ca.conf \
    -out ca/software-ca.csr \
    -keyout ca/software-ca/private/software-ca.key

# Create CA certificate
openssl ca \
    -config etc/root-ca.conf \
    -in ca/software-ca.csr \
    -out ca/software-ca.crt \
    -extensions signing_ca_ext

# Create initial CRL
openssl ca -gencrl \
    -config etc/software-ca.conf \
    -out crl/software-ca.crl

# Create PEM bundle
cat ca/software-ca.crt ca/root-ca.crt > \
    ca/software-ca-chain.pem
