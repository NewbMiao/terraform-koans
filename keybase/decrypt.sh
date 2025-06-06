#!/bin/bash
# run with encrypted_secret.txt which is generated after terraform apply
secret=$(cat encrypted_secret.txt)
keybase pgp decrypt <<<"$secret" | jq -R '{data: .}'
