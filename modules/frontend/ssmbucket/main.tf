# ### creating s3 bucket for ssm
# resource "aws_s3_bucket" "ssm_ansible_bucket" {
#   bucket = "ansible-s3-bucket-omokaro"

#   force_destroy = true


#   # server_side_encryption_configuration {
#   #   rule {
#   #     apply_server_side_encryption_by_default {
#   #       sse_algorithm = "AES256"
#   #     }
#   #   }
#   # }

#   tags = {
#     Name        = "ansible-ssm-bucket"
#     Environment = "shared"
#   }

# #   lifecycle {
# #     prevent_destroy = true
# #   }
# }

# # Enable versioning (recommended for Terraform state)
# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.ssm_ansible_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }


## data for an existing s3 bucket
data "aws_s3_bucket" "github_ssh_key_bucket" {
  bucket = "ansible-s3-bucket-omokaro" # Replace with your actual S3 bucket name
}

# s3 bucket versioning from an existing bucket
# data "aws_s3_bucket_versioning" "github_ssh_key_bucket_versioning" {
#   bucket = data.aws_s3_bucket.github_ssh_key_bucket.id

#    versioning_configuration {
#      status = "Enabled"
#    }

#    force_destroy = true

#   tags = {
#      Name        = "ansible-ssm-bucket"
#      Environment = "shared"
#    }
# }

