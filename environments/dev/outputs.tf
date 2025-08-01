output "alb-name" {
  value = module.alb.alb_name
}

output "shared_ssm_bucket_name" {
  value = module.ssm.ssm_bucket_name
}

output "github_key" {
  value = module.iam.github_key
  
}

