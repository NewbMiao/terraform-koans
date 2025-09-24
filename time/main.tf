terraform {
  required_version = ">= 1.9.2"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13.1"
    }
  }
}
variable "secret_data" {
  description = "Secret data to trigger timestamp update"
  type        = string
}
resource "time_static" "timestamp" {
  triggers = {
    "data" = sensitive(var.secret_data)
  }
}
output "gen_timestamp_when_data_changes" {
  value = time_static.timestamp.rfc3339
}
