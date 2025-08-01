provider "aws" {
  region = var.aws_region
}

variable "asg_name" {
  description = "The name prefix for the Auto Scaling Group"
  type        = string
}

module "iam" {
  source  = "../../modules/frontend/iam"
  project = var.project
  # Env = var.env
  
}

module "networking" {
  source               = "../../modules/frontend/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  env                  = var.env
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source  = "../../modules/frontend/security"
  vpc_id  = module.networking.vpc_id
  env     = var.env
  prefix  = var.vpc_name
}

module "alb" {
  source             = "../../modules/frontend/alb"
  env                = var.env
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  lb_name            = "${var.vpc_name}-alb"
  prefix             = var.vpc_name
  alb_security_group_id = module.security.alb_sg_id
}

module "autoscaling" {
  source                = "../../modules/frontend/autoscaling"
  vpc_security_group_ids = [module.security.autoscaling_ec2]
  private_subnet_ids     = module.networking.private_subnet_ids
  target_group_arns      = [module.alb.target_group_arn]
  env                    = var.env
  asg_name               = "${var.asg_name}-asg"
  launch_template_name   = "${var.asg_name}-lt"
  ami_id                 = var.ami_id
  instance_profile_name  = module.iam.instance_profile_name
  instance_type          = var.instance_type
  user_data_path         = var.user_data_path
}


module "ssm" {
  source = "../../modules/frontend/ssmbucket"
}

# to access the private ec2 
# aws ssm start-session --target <INSTANCE_ID>

# module "githubkey" {
#   source = "../../modules/frontend/"
  
# }