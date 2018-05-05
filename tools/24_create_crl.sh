#!/bin/bash

set -x
cd ..

openssl ca -gencrl \
    -config etc/tls-ca.conf \
    -out crl/tls-ca.crl
