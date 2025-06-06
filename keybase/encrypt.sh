#!/bin/bash
keybase_user="newbmiao_test" # Set your Keybase username here
secret="secret_value_placeholder"
echo -e "$(echo "$secret" | keybase pgp encrypt $keybase_user)"
