terraform {
  backend "s3" {
    bucket         = "ansible-s3-bucket-omokaro"
    # key            = "dev/terraform.tfstate"
    key = "prod/terraform/state/terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
