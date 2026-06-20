#!/bin/bash

set -euxo pipefail
cd ..

openssl ca -gencrl \
    -config etc/tls-ca.conf \
    -out crl/tls-ca.crl
