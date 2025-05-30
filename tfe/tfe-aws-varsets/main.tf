# create tfe user in master account, generate access key and to assume member account tfe role
# so tfe use the member account role to manage resources in member account
resource "aws_iam_user" "tfe_user" {
  name = "tfe-user"
}
resource "aws_iam_access_key" "tfe_user_ak" {
  user = aws_iam_user.tfe_user.name
}


resource "aws_iam_role" "tfe_member_role" {
  provider             = aws.member
  name                 = "tfe-member-role"
  assume_role_policy   = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${aws_iam_user.tfe_user.id}:user/tfe-user"
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
  max_session_duration = 3600
  depends_on           = [aws_iam_user.tfe_user]
}
resource "aws_iam_role_policy_attachment" "tfe_member_role_attachment" {
  provider   = aws.member
  role       = aws_iam_role.tfe_member_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [aws_iam_user.tfe_user, aws_iam_role.tfe_member_role]
}
resource "aws_iam_user_policy" "tfe_user_assume_role" {
  name = "tfe-user-assume-role"
  user = aws_iam_user.tfe_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.tfe_member_role.arn
      }
    ]
  })
  depends_on = [aws_iam_role.tfe_member_role]
}
output "tfe_user_role_arn" {
  description = "The ARN of the TFE user role"
  value       = aws_iam_role.tfe_member_role.arn
}
output "tfe_user_access_key_id" {
  description = "The access key ID of the TFE user"
  value       = aws_iam_access_key.tfe_user_ak.id
  sensitive   = true
}
output "tfe_user_access_key_secret" {
  description = "The access key secret of the TFE user"
  value       = aws_iam_access_key.tfe_user_ak.secret
  sensitive   = true
}
output "tfe_user_name" {
  description = "The name of the TFE user"
  value       = aws_iam_user.tfe_user.name
}
locals {
  tfe_project_ids = {
    cloudplatform = {
      project_id    = "prj-ifPU81zqNih2NHxM"
      workspace_ids = []
    }
  }
}
# set tfe user access key and role arn to tfe variable set
resource "tfe_variable_set" "tfe_varset_cloudplatform" {
  for_each          = local.tfe_project_ids
  name              = "${each.key}-aws-tfe-account"
  parent_project_id = each.value.project_id
  workspace_ids     = each.value.workspace_ids
  description       = "AKSK ENV Set for AWS TFE account in project ${each.key}"
  priority          = false
}

resource "tfe_variable" "cloudplatform_aws_access_key" {
  for_each        = local.tfe_project_ids
  key             = "AWS_ACCESS_KEY_ID"
  value           = aws_iam_access_key.tfe_user_ak.id
  category        = "env"
  sensitive       = true
  description     = "AWS access key for TFE"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
resource "tfe_variable" "cloudplatform_aws_access_secret" {
  for_each        = local.tfe_project_ids
  key             = "AWS_SECRET_ACCESS_KEY"
  value           = aws_iam_access_key.tfe_user_ak.secret
  category        = "env"
  sensitive       = true
  description     = "AWS secret key for TFE"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
resource "tfe_variable" "cloudplatform_aws_role_arn" {
  for_each        = local.tfe_project_ids
  key             = "AWS_ROLE_ARN"
  value           = aws_iam_role.tfe_member_role.arn
  category        = "env"
  description     = "AWS assume role ARN for TFE"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
resource "tfe_variable" "cloudplatform_aws_region" {
  for_each        = local.tfe_project_ids
  key             = "AWS_REGION"
  value           = "us-east-1"
  category        = "env"
  description     = "AWS default region for TFE"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
