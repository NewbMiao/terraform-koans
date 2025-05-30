resource "null_resource" "encrypt_secret" {
  provisioner "local-exec" {
    command = <<EOT
        echo "${local.secret}" | keybase pgp encrypt ${local.keybase_user} > ${path.module}/encrypted_secret.txt
    EOT
  }
}

resource "null_resource" "decrypt_secret" {
  depends_on = [null_resource.encrypt_secret]

  provisioner "local-exec" {
    command = <<EOT
        if [ ! -f "${path.module}/encrypted_secret.txt" ]; then
            echo "Encrypted file not found!"
            exit 1
        fi
        echo "${try(file("${path.module}/encrypted_secret.txt"), "")}" | keybase pgp decrypt > ${path.module}/decrypted_secret.txt
    EOT
  }
}

output "secret_encrypted_file" {
  value = try(file("${path.module}/encrypted_secret.txt"), "not found")
}

output "secret_decrypted_file" {
  value = try(file("${path.module}/decrypted_secret.txt"), "not found")
}
