variable "aliyun_access_key" {
  type        = string
  description = "value of the Alibaba Cloud access key"
  sensitive   = true
}

variable "aliyun_secret_key" {
  description = "value of the Alibaba Cloud secret key"
  type        = string
  sensitive   = true
}
