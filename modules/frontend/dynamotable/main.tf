# resource "aws_dynamodb_table" "tf_locks" {
#   name = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "Terraform Lock Table"
#     Environment = "shared"
#   }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-state-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name        = "terraform-state-lock"
#     Environment = "shared"
#   }
# }


# DynamoDB table for state locking
# resource "aws_dynamodb_table" "tf_locks" {
#   name         = var.dynamodb_table_name
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name        = "Terraform Lock Table"
#     Environment = "shared"
#   }
# }



######
# resource "aws_dynamodb_table" "tf_locks" {
#   name         = "terraform-state-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name        = "Terraform Lock Table"
#     Environment = "shared"
#   }
# }