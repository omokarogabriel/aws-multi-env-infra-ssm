output "instance_profile_name" {
  value = aws_iam_instance_profile.ssm_profile.name
}

output "github_key" {
  value = aws_secretsmanager_secret.my_github_ssh_key.arn
}