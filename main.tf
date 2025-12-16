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

# IAM Role with inline policy that allows all service actions
# This is Policy 1600: IAM Role Inline policy allows all service actions
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
    Name        = "Policy-1600-Test-Role"
    Environment = "sandbox"
    Purpose     = "Security testing - Policy 1600"
  }
}

# Inline policy that allows all service actions (the misconfiguration)
resource "aws_iam_role_policy" "policy_1600_inline_policy" {
  name = "policy-1600-inline-policy"
  role = aws_iam_role.policy_1600_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

# Optional: Instance profile to attach the role to an EC2 instance
resource "aws_iam_instance_profile" "policy_1600_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.policy_1600_role.name
}
