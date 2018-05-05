#!/bin/bash

set -x
cd ..

# like uuid
dir=$1
# like xiexianbin.cn
cert_name=$2
# san like DNS:xiexianbin.cn,DNS:www.xiexianbin.cn
san=$3

mkdir certs/${dir}

# Create TLS server request
SAN=${san} \
openssl req -new \
    -config etc/server.conf \
    -out certs/${dir}/${cert_name}.csr \
    -keyout certs/${dir}/${cert_name}.key

# Create TLS server certificate
openssl ca \
    -config etc/tls-ca.conf \
    -in certs/${dir}/${cert_name}.csr \
    -out certs/${dir}/${cert_name}.crt \
    -extensions server_ext

# Create PKCS#12 bundle
openssl pkcs12 -export \
    -name "${cert_name}" \
    -caname "X TLS CA 1C1" \
    -caname "X Root CA - R1" \
    -inkey certs/${dir}/${cert_name}.key \
    -in certs/${dir}/${cert_name}.crt \
    -certfile ca/tls-ca-chain.pem \
    -out certs/${dir}/${cert_name}.p12

cat certs/${dir}/${cert_name}.crt ca/tls-ca-chain.pem > certs/${dir}/${cert_name}.bundle.crt
