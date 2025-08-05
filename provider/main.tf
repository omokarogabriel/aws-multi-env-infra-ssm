terraform {
  # backend "s3" {
  #   bucket = "ansible-ssm-bucket-omokaro"
  #   key = "dev/terraform/state/terraform.tfstate"
  #   region = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt = true
  # }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  #   access_key = var.access_key
  #   secret_key = var.secret_key
}