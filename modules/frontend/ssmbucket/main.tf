### creating s3 bucket for ssm
resource "aws_s3_bucket" "ssm_ansible_bucket" {
  bucket = "ansible-ssm-bucket-omokaro"

  force_destroy = true

  tags = {
    Name        = "ansible-ssm-bucket"
    Environment = "shared"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}
