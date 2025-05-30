#!/bin/bash
secret=$(cat encrypted_secret.txt)
keybase pgp decrypt <<< "$secret" | jq -R '{data: .}'
