provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"
  endpoints {
    sqs        = "http://localhost:4566"
    sns        = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    iam        = "http://localhost:4566"
    cloudwatch = "http://localhost:4566"
    events     = "http://localhost:4566"
  }
}

provider "aws" {
  alias                       = "member"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"
  endpoints {
    sqs        = "http://localhost:4566"
    sns        = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    iam        = "http://localhost:4566"
    cloudwatch = "http://localhost:4566"
    events     = "http://localhost:4566"
  }
}
# if use tflocal, then no need to configure aws provider, it will use the localstack by default
# provider "aws" {}
# provider "aws" {
#   alias = "member"
# }
provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "newbmiao"
}
