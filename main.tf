terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  # Use default credentials from AWS CLI or environment variables
  # For sandbox account, ensure AWS_PROFILE or credentials are configured
}

# IAM Role with secure inline policy following least privilege principle
# Fixed: Previously had Policy 1600 misconfiguration (wildcard actions)
# Now uses minimal required permissions for EC2 instance operations
resource "aws_iam_role" "policy_1600_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "Secure-EC2-Role"
    Environment = "sandbox"
    Purpose     = "Secure IAM role with least privilege"
  }
}

# Secure inline policy with minimal required permissions
# Fixed: Replaced wildcard actions with specific, scoped permissions
resource "aws_iam_role_policy" "policy_1600_inline_policy" {
  name = "secure-ec2-policy"
  role = aws_iam_role.policy_1600_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/aws/ec2/*"
      }
    ]
  })
}

# Instance profile to attach the role to an EC2 instance
resource "aws_iam_instance_profile" "policy_1600_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.policy_1600_role.name
  
  tags = {
    Name        = "Secure-EC2-Instance-Profile"
    Environment = "sandbox"
  }
}
