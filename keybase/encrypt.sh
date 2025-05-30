#!/bin/bash
keybase_user="" # Set your Keybase username here
echo -e "$(echo "$secret" | keybase pgp encrypt $keybase_user)"
