### CREATE A ROLE ###
resource "aws_iam_role" "ssm_ec2_role" {
  name = "${var.project}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project}-ec2-ssm-role"
  }
}

### ATTACH SSM MANAGED POLICY ###
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

### INSTANCE PROFILE ###
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project}-ssm-profile"
  role = aws_iam_role.ssm_ec2_role.name
}

### ADD INLINE POLICY FOR S3 BUCKET ACCESS ###
resource "aws_iam_policy" "ssm_s3_access" {
  name        = "${var.project}-ssm-s3-policy"
  description = "Allow SSM to use the Ansible S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::ansible-ssm-bucket-omokaro",
          "arn:aws:s3:::ansible-ssm-bucket-omokaro/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_s3" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = aws_iam_policy.ssm_s3_access.arn
}

######github private key aws secret manager

resource "aws_secretsmanager_secret" "my_github_ssh_key" {
  name        = "my-github_ssh_private_keys9"
  description = "SSH private key for accessing GitHub repositories"
  
}

# data for an existing s3 bucket
# data "aws_s3_bucket" "github_ssh_key_bucket" {
#   bucket = "ansible-ssm-bucket-omokaro" # Replace with your actual S3 bucket name
# }



resource "aws_secretsmanager_secret_version" "my_github_ssh_key_version" {
  secret_id     = aws_secretsmanager_secret.my_github_ssh_key.id
  # secret_string = file("${path.module}/latest_github_key") # Path to your SSH private key file
  secret_string =   local.github_ssh_private_key # This should point to the local variable defined in the githubkey module
}


# OPTION 1: Updated IAM policy that allows the EC2 role to access AND update the GitHub SSH key
resource "aws_iam_policy" "github_ssh_key_policy" {
  name        = "github-ssh-key-access-policy"
  description = "Allow EC2 role to access and update GitHub SSH key from Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowReadGitHubSSHKey",
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = aws_secretsmanager_secret.my_github_ssh_key.arn
      }
      # {
      #   Sid = "AllowUpdateGitHubSSHKey",
      #   Effect = "Allow",
      #   Action = [
      #     "secretsmanager:UpdateSecret"
      #   ],
      #   Resource = aws_secretsmanager_secret.my_github_ssh_key.arn
      # }
    ]
  })
}

####Attach the github policy to the role

resource "aws_iam_role_policy_attachment" "github_key" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = aws_iam_policy.github_ssh_key_policy.arn
}