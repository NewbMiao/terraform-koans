

resource "acme_registration" "reg" {
  email_address = "newbvirgil@gmail.com"
}

resource "acme_certificate" "wildcard_multi_domains" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = "*.demo.com" # 主域名

  subject_alternative_names = [
    "*.sub.demo.com"
  ]

  dns_challenge {
    provider = "alidns"
    config = {
      ALICLOUD_ACCESS_KEY = var.aliyun_access_key
      ALICLOUD_SECRET_KEY = var.aliyun_secret_key
    }
  }

  min_days_remaining = 30
}
