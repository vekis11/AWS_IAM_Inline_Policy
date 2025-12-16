output "iam_role_arn" {
  description = "ARN of the IAM role with Policy 1600 misconfiguration"
  value       = aws_iam_role.policy_1600_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.policy_1600_role.name
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.policy_1600_profile.name
}
