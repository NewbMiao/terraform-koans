# apis.tf
# enable first https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com
resource "google_project_service" "cloud_resource_manager_api" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "iam_api" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_credentials_api" {
  service                    = "iamcredentials.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = true
}

resource "google_project_service" "sts_api" {
  service            = "sts.googleapis.com"
  disable_on_destroy = false
}
