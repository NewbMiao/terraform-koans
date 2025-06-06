#!/bin/bash

brew install localstack
localstack start -d

# use tflocal to run terraform without confiugre localstack aws provider
# pip3 install terraform-local
# or
# terraform init
terraform plan
terraform apply -auto-approve
