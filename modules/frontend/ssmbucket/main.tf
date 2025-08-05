### creating s3 bucket for ssm
resource "aws_s3_bucket" "ssm_ansible_bucket" {
  bucket = "ansible-s3-bucket-omokaro"

  force_destroy = true


  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }

  tags = {
    Name        = "ansible-ssm-bucket"
    Environment = "shared"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

# Enable versioning (recommended for Terraform state)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.ssm_ansible_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
