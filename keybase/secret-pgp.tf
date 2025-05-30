data "external" "encrypt_secret_pgp" {
  program = ["bash", "-c", <<EOT

    echo $(echo "${local.secret}" | keybase pgp encrypt ${local.keybase_user}|tr '\n' '|')|jq -R '{data: .}'
EOT
  ]
}

data "external" "decrypt_secret_pgp" {
  program = ["bash", "-c", <<EOT
    echo $(keybase pgp decrypt <<<$(echo "${data.external.encrypt_secret_pgp.result.data}" |tr '|' '\n'))|jq -R '{data: .}'
EOT
  ]

  depends_on = [data.external.encrypt_secret_pgp]
}


output "secret_encrypted_external_pgp" {
  value = replace(data.external.encrypt_secret_pgp.result.data, "|", "\n")
}

output "secret_decrypted_external_pgp" {
  value = data.external.decrypt_secret_pgp.result.data
}
