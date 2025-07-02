
output "full_certificate_pem" {
  value     = "${acme_certificate.wildcard_multi_domains.certificate_pem}${acme_certificate.wildcard_multi_domains.issuer_pem}"
  sensitive = true
}

output "private_key_pem" {
  value     = acme_certificate.wildcard_multi_domains.private_key_pem
  sensitive = true
}
