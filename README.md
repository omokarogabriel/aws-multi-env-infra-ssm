##### **3 TIER TERRAFORM CONFIGURATION FOR MULTI ENVIRONMENT ALSO USING AWS SSM FOR CONNECTION**

####  PREREQUISTE FOR THIS CONFIGURATION
- SETUP YOUR TERMINAL WITH ANY CLOUD PROVIDERS(AWS, GCP OR AZURE) USER ACCESS KEY AND ACCESS VALUE
- INSTALL TERRAFORM ON YOUR HOST MACHINE

### FRONTEND TIER

**THE VPC HAS IT OWN CIDR BLOCK FOR EACH ENVIRONMENT**
**THE INTERNET GATEWAY HAS BEEN CONNECTED TO THE VPC**
**THE SUBNET CIDR DETERMINES THE NETWORK AVAILABLE**
**THIS INFRASTRUCTURE USES DATA AVAILABLE ZONES, AND WILL BE ASSIGNED TO THE SUBNETS**
**THE ROUTE AND ROUTE TABLE IS BEEN CONFIGURED WITH THE APPOPRIATE SUBNET(i.e PUBLIC SUBNET) AND IS BEEN LINKED TO THE INTERNET GATEWAY**
**THE SECURITY GROUP HAS THE NECCESSARY PORT FOR INCOMING TRAFFIC(PORT HTTP : 80 AND PORT HTTPS : 443)**
**THIS TIER USES SSM FOR CONNECTING TO THE SERVERS, BUT THE SERVER INSTANCE MUST HAVE THE SSM AGENT UP AND RUNNING**
**IT USES CLOUDWATCH WITH SCALING POLICY AUTOMATICALLY**

*NOTE: THE SSM AGENT IS AUTOMATICALLY INSTALLED IF USING AMAZON LINUX OR THE UBUNTU LINUX FROM 22 LTS, THE MEANS THE IMAGE BOX*
*NOTE: AND IF NOT USING THE ABOVE PREREQUISTE, KINDLY FOLLOW THE STEP BELOW*

```bash
# Install the SSM Agent via snap (only if not already present)
if ! sudo systemctl status amazon-ssm-agent >/dev/null 2>&1; then
    sudo snap install amazon-ssm-agent --classic
fi

# Start and enable the SSM agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

#  THIS WILL BE PASS INTO A USERDATA SCRIPT
```

**IT HAS A ROLE, WITH AN ATTACHMENT POLICY FOR SSM AND A PROFILE**
*NOTE: BELOW IS THE ROLE AND POLICY  AND PROFILE, WITH OUT THIS THE SSM WONT WORK*
```hcl

# ROLE
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

###SSM ROLE POLICY###

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


###INSTANCE PROFILE###

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project}-ssm-profile"
  role = aws_iam_role.ssm_ec2_role.name
}


```
## WE HAVE BOTH PUBLIC SUBNET AND PRIVATE SUBNET

## **THE PUBLIC SUBNET CONATAINS THE APPLICATION LOAD BALANCER AND THE NAT GATEWAY**

*NOTE: THE NAT GATEWAY GIVES THE PRIVATE SUBNET ACCESS TO THE INTERNET FROM THE ABOVE SETTING, BECAUSE THE SUBNET IS AT HAS THE DIRECT INTERNET ACCESS*

## **THE PRIVATE SUBNET CONTAINS THE EC2 INSTANCE THAT ALSO SCALE AUTOMATICALLY WHEN IT REACH A CERTAIN THRESHOLD**

*NOTE: THIS IS WHERE THE SSM AGENT WILL BE INSTALLED AND BE UP AND RUNNING AND MUST BE PASSED THROUGH A USERDATA SCRIPT*

*EACH PRIVATE SUBNET HAS A NAT GATEWAY AND AN EIP AND THE AZ IS DYNAMIC TO AVOID CROSS ZONES TO AVOID CHARGES*

*NOTE: THE SUBNET CIDR BLOCK DETERMINES HOW MANY NAT GATEWAY,EIP AND AVAILABLE ZONE THERE WILL BE*


## **IT IS CLOUDWATCH ENABLEB, THAT MONITOR THE EC2 INSTANCE**

*THE SNIPPET BELOW SHOWS THE LAUNCH TEMPLATE, AUTO SCALING GROUP AND AUTOMATIC SCALING POLICY*

```hcl

resource "aws_launch_template" "asg_template" {
  name_prefix   = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  # key_name      = var.key_name

  vpc_security_group_ids = var.vpc_security_group_ids

  iam_instance_profile {
    name = var.instance_profile_name
  }

  # user_data = filebase64("${path.module}/frontend/scripts/user_data.sh")
  user_data = filebase64(var.user_data_path)


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.asg_name}-instance"
      Env         = var.env
      SSMManaged  = "true"
      # NOTE: IT SHOULD BE, SSMManaged  = "true" FROM THE ABOVE SNIPPET
    }
  }
}



###AUTO-SCALING GROUP###

resource "aws_autoscaling_group" "web_asg" {
  name                      = var.asg_name
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = var.target_group_arns
  health_check_type         = "EC2"
  health_check_grace_period = 60
  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }
  

  tag {
    key                 = "Name"
    value               = "${var.asg_name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


###SCALING POLICY AUTOMATIC###
resource "aws_autoscaling_policy" "target_tracking_cpu" {
  name                   = "${var.asg_name}-target-tracking-cpu"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value       = 50.0  # Aim to maintain 50% average CPU
    # cooldown           = 60    # Optional: wait time after a scale action
    # disable_scale_in   = false # Allow scale in (true = only scale out)
  }
}
```




