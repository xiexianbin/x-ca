#!/bin/bash

set -euxo pipefail
cd ..

if [ $# -ne 1 ]; then
    echo "Usage: $0 <cert_path>" >&2
    echo "  example: $0 certs/abc123/xiexianbin.cn.crt" >&2
    exit 1
fi
cert_path=$1

# Revoke certificate
openssl ca \
    -config etc/tls-ca.conf \
    -revoke "$cert_path" \
    -crl_reason affiliationChanged
