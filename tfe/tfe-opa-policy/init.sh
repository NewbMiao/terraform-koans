# install sentinel https://docs.hashicorp.com/sentinel/install
# VERSION=0.40.0
# wget https://releases.hashicorp.com/sentinel/$VERSION/sentinel_$VERSION_darwin_arm64.zip
# unzip sentinel_$VERSION_darwin_arm64.zip
# sudo mv sentinel /usr/local/bin

# # or opa

# curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.66.0/opa_linux_amd64
# chmod +x ./opa
# sudo mv ./opa /usr/local/bin/opa

# terraform init
# terraform plan -out=plan.out
# terraform show -json plan.out > tfplan.json

# opa eval --data policies/deny_secret_files.rego --input tfplan.json 'data.terraform.deny'
