
# This resource should PASS the policy check.
resource "local_file" "user_data" {
  filename = "${path.module}/data.txt"
  content  = "This is user data."
}

# This resource should BE DENIED by the policy.
# Its filename starts with "secret".
resource "local_file" "app_secret" {
  filename = "${path.module}/secret-credentials.txt"
  content  = "sensitive-info"
}
