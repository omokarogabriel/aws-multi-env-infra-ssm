###VPC###

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
# }

# variable "vpc_name" {
#   description = "Name for the VPC"
#   type        = string
# }


# variable "env" {
#   description = "Environment for the VPC (e.g., dev, prod)"
#   type        = string
# }


# variable "public_cidr" {
#   description = "cidr for public subnets"
#   type = list(string)
# }

# variable "private_cidr" {
#   description = "cidr for private subnets"
#   type = list(string)
# }






variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}
