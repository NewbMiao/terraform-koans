#!/bin/bash
brew install localstack
localstack start -d

# terraform init
terraform plan
terraform apply -auto-approve