terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.9.0"
}
locals {
  file_md5 = filemd5("${path.module}/file-to-zip")
}
data "archive_file" "zipfile" {
  type        = "zip"
  source_file = "${path.module}/file-to-zip"
  output_path = "${path.module}/file.${local.file_md5}.zip"
}

output "zipfile_path" {
  value      = data.archive_file.zipfile.output_path
  depends_on = [data.archive_file.zipfile]

}
