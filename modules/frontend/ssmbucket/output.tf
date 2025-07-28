###ssmbucket output file
output "ssm_bucket_name" {
  value = aws_s3_bucket.ssm_ansible_bucket.bucket
}

output "ssm_bucket_arn" {
  value = aws_s3_bucket.ssm_ansible_bucket.arn
}

