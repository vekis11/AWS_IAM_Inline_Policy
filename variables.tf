variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "policy-1600-test-role"
}
