variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR"
  type = list(string)
}  

variable "private_subnet_cidrs" {
  description = "list of private subnet CIDRS"
  type = list(string)
}

variable "vpc_cidr" {
  description = "vpc CIDR block"
  type = string
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "env" {
  description = "application environment"
  type = string
}

variable "ami_id" {
  description = "the OS of the server"
  type = string
}

variable "project" {
  description = "the roles for the autoscaling ec2"
  type = string
}

variable "aws_region" {
  description = "the regoin for the resources"
  type = string
}

# variable "instance_profile_name" {
#   description = "role profile name"
#   type = string
# }

variable "instance_type" {
  description = "instance type"
  type = string
}

variable "user_data_path" {
  description = "Path to the user data script"
  type        = string
}

# variable "dynamo_table_name" {
#   description = "The name of the DynamoDB table for state locking"
#   type        = string

# }

variable "asg_name" {
  description = "The name prefix for the Auto Scaling Group"
  type        = string
}

# variable "dynamodb_table_name" {
#   description = "The name of the DynamoDB table"
#   type        = string
# }