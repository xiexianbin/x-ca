#!/bin/bash

set -x
cd ..

# Revoke certificate
openssl ca \
    -config etc/tls-ca.conf \
    -revoke ca/tls-ca/pem \
    -crl_reason affiliationChanged
