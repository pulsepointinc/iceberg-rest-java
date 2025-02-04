#!/bin/bash

kinit -V -k "${KRB_PRINCIPAL}"

while :; do
    sleep 3600
    # -R renew
    kinit -V -R -k "${KRB_PRINCIPAL}"
done
