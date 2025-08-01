# locals {
#   github_ssh_private_key = file("${path.module}/latest_github_key") # Path to your SSH private key file
# }

locals {
  github_ssh_private_key = file("${path.module}/../latest_github_key") # Path to your SSH private key file
}