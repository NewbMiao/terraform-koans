
resource "null_resource" "install_deps" {
  triggers = {
    package_json = filemd5("${path.module}/dep/package.json") # Re-run if package.json changes
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/dep && \
      mkdir -p nodejs 
      cp package.json nodejs/
      npm install --target_arch=x64 --production --prefix nodejs
    EOT
  }
}
data "archive_file" "nodejs_layer" {
  type        = "zip"
  source_dir  = "${path.module}/dep/nodejs" # Path to the layer dir
  output_path = "${path.module}/dep.zip"

  depends_on = [null_resource.install_deps] # Wait for deps to install
}

output "dep_zipfile_path" {
  value      = try(data.archive_file.nodejs_layer.output_path, "")
  depends_on = [data.archive_file.nodejs_layer]
}
