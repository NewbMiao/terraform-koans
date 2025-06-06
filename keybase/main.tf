locals {
  secret       = "secret_value_placeholder"
  keybase_user = "newbmiao_test" # Replace with your Keybase username
}

data "external" "encrypt_secret" {
  program = ["bash", "-c", <<EOT

    echo $(echo "${local.secret}" | keybase encrypt ${local.keybase_user})|jq -R '{data: .}'
EOT
  ]
}

data "external" "decrypt_secret" {
  program = ["bash", "-c", <<EOT
    echo $(keybase decrypt <<<"${data.external.encrypt_secret.result.data}") | jq -R '{data: .}'
EOT
  ]

  depends_on = [data.external.encrypt_secret]
}

output "secret_encrypted_external" {
  value = data.external.encrypt_secret.result.data
}

output "secret_decrypted_external" {
  value = data.external.decrypt_secret.result.data
}
