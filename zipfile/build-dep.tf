
resource "null_resource" "install_deps" {
  triggers = {
    package_json = filemd5("${path.module}/dep/package.json") # Re-run if package.json changes
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/dep && \
      mkdir -p nodejs 
      cp package.json nodejs/
      npm install --omit=dev --prefix nodejs # ensure run it in the correct nodejs runtime, e.g. node:20-bullseye
    EOT
  }
}
data "archive_file" "nodejs_layer" {
  type        = "zip"
  source_dir  = "${path.module}/dep/" # Path to the layer dir https://help.aliyun.com/zh/functioncompute/fc/user-guide/create-a-custom-layer-1?spm=a2c4g.11186623.help-menu-2838607.d_2_6_3_0.2aa15de9n35m8r&scm=20140722.H_2513609._.OR_help-T_cn~zh-V_1#p-zqv-80h-rua
  output_path = "${path.module}/dep.zip"

  depends_on = [null_resource.install_deps] # Wait for deps to install
}

output "dep_zipfile_path" {
  value      = try(data.archive_file.nodejs_layer.output_path, "")
  depends_on = [data.archive_file.nodejs_layer]
}
