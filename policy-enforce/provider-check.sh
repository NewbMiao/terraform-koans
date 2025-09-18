terraform init
source .env
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
echo "provider policy enforce checking..."
# use conftest
conftest test tfplan.json -p ./policy/ --namespace terraform -o pretty
# simlar to opa eval but with validation
opa eval -i tfplan.json -d ./policy/enforce_alicloud_provider.rego "data.terraform.deny" -f pretty
