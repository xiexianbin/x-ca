#!/bin/bash

set -euxo pipefail
cd ..

if [ $# -ne 3 ]; then
    echo "Usage: $0 <dir> <cert_name> <san>" >&2
    echo "  san example: DNS:xiexianbin.cn,DNS:www.xiexianbin.cn" >&2
    exit 1
fi

# like uuid
dir=$1
# like xiexianbin.cn
cert_name=$2
# san like DNS:xiexianbin.cn,DNS:www.xiexianbin.cn
san=$3

mkdir -p "certs/${dir}"

# Create TLS server request
SAN=${san} \
openssl req -new \
    -config etc/server.conf \
    -out "certs/${dir}/${cert_name}.csr" \
    -keyout "certs/${dir}/${cert_name}.key"

# Create TLS server certificate
# SAN is injected via $ENV::SAN in tls-ca.conf [ server_ext ] (copy_extensions=none)
SAN=${san} \
openssl ca \
    -config etc/tls-ca.conf \
    -in "certs/${dir}/${cert_name}.csr" \
    -out "certs/${dir}/${cert_name}.crt" \
    -extensions server_ext

# Create PKCS#12 bundle
openssl pkcs12 -export \
    -name "${cert_name}" \
    -caname "X TLS CA 1C1" \
    -caname "X Root CA - R1" \
    -inkey "certs/${dir}/${cert_name}.key" \
    -in "certs/${dir}/${cert_name}.crt" \
    -certfile ca/tls-ca-chain.pem \
    -out "certs/${dir}/${cert_name}.p12"

cat "certs/${dir}/${cert_name}.crt" ca/tls-ca-chain.pem > "certs/${dir}/${cert_name}.bundle.crt"
