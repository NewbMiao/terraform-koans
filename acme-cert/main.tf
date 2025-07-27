

# Tips: zerossl requires a registration to issue certificates, while let's encrypt does not require registration
# https://community.letsencrypt.org/t/the-acme-sh-will-change-default-ca-to-zerossl-on-august-1st-2021/144052/11
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
