# Terraform IAM Policy 1600 - Security Testing Infrastructure

This repository contains Terraform infrastructure that intentionally deploys **Policy 1600: IAM Role Inline policy allows all service actions** to an AWS sandbox account. This is a security misconfiguration used for testing and demonstrating IaC security scanning tools.

## 🎯 Purpose

This project demonstrates:
1. How to deploy a known IAM security misconfiguration (Policy 1600)
2. How to set up automated IaC security scanning workflows
3. How multiple free security scanning tools can detect misconfigurations

## ⚠️ Security Warning

**This infrastructure intentionally creates a security vulnerability.** The IAM role has an inline policy that allows all actions (`*`) on all resources (`*`). 

**DO NOT deploy this to production or any account with sensitive resources.**

## 📋 Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Access to an AWS sandbox/test account
- GitHub account (for CI/CD workflows)

## 🏗️ Infrastructure Components

### IAM Role with Policy 1600 Misconfiguration

The Terraform configuration creates:
- **IAM Role**: `policy-1600-test-role` (configurable)
- **Inline Policy**: Allows all service actions (`Action: "*"`, `Resource: "*"`)
- **Instance Profile**: For attaching the role to EC2 instances

### Policy 1600 Details

**Policy ID**: CKV_AWS_274 (Checkov) / AWS.IAM.IAMRole.AllowAllActions (Terrascan)

**Issue**: IAM role inline policy allows all service actions, which violates the principle of least privilege.

**Risk Level**: HIGH

## 🚀 Deployment

### 1. Configure AWS Credentials

```bash
# Option 1: AWS CLI profile
export AWS_PROFILE=sandbox

# Option 2: Environment variables
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=us-east-1
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Deploy (at your own risk)

```bash
terraform apply
```

### 5. Destroy Resources

```bash
terraform destroy
```

## 🔍 Security Scanning Tools

This project includes workflows for multiple free IaC security scanning tools:

### 1. **Checkov** (Bridgecrew)
- **Framework**: Terraform, CloudFormation, Kubernetes, etc.
- **Detection**: Policy 1600 detected as `CKV_AWS_274`
- **Free Tier**: Open source, unlimited scans
- **GitHub Action**: `bridgecrewio/checkov-action`

### 2. **Terrascan** (Tenable)
- **Framework**: Multi-cloud (AWS, Azure, GCP, etc.)
- **Detection**: Policy 1600 detected as `AWS.IAM.IAMRole.AllowAllActions`
- **Free Tier**: Open source, unlimited scans
- **GitHub Action**: `tenable/terrascan-action`
- **Output**: SARIF format for GitHub Security tab

### 3. **tfsec** (Aqua Security)
- **Framework**: Terraform-specific
- **Detection**: Policy 1600 detected as `AWS048`
- **Free Tier**: Open source, unlimited scans
- **GitHub Action**: `aquasecurity/tfsec-action`

### 4. **Secrets Scanning**
- **TruffleHog**: Detects secrets, credentials, and API keys
- **Gitleaks**: Git-based secrets detection

## 🔄 CI/CD Workflow

The GitHub Actions workflow (`.github/workflows/iac-scanning.yml`) automatically runs:

1. **Terraform Validation**: Validates Terraform syntax and configuration
2. **Checkov Scan**: Comprehensive security and compliance scanning
3. **Terrascan Scan**: Multi-cloud security scanning with SARIF output
4. **tfsec Scan**: Terraform-specific security checks
5. **Secrets Scanning**: TruffleHog and Gitleaks for credential detection
6. **Scan Summary**: Aggregated results in GitHub Actions summary

### Running the Workflow

The workflow triggers on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual trigger via `workflow_dispatch`

### Viewing Results

1. **GitHub Actions Tab**: View workflow runs and results
2. **Artifacts**: Download detailed scan reports
3. **Security Tab**: View Terrascan SARIF results (if enabled)
4. **Pull Request Comments**: Some tools may comment on PRs

## 📊 Expected Scan Results

When scanning this infrastructure, you should see detections for:

### Checkov
```
Check: CKV_AWS_274: "Ensure IAM role policies that allow full "*:*" administrative privileges are not created"
	FAILED for resource: aws_iam_role_policy.policy_1600_inline_policy
```

### Terrascan
```
Rule: AWS.IAM.IAMRole.AllowAllActions
Severity: HIGH
Description: IAM role policy allows all actions
```

### tfsec
```
Rule: AWS048
Severity: HIGH
Description: IAM role policy allows wildcard actions
```

## 🛠️ Customization

### Variables

Edit `variables.tf` to customize:
- `aws_region`: AWS region for deployment
- `role_name`: Name of the IAM role

### Scanning Configuration

- **Checkov**: Edit `checkov-config.yml`
- **Gitleaks**: Edit `.gitleaks.toml`
- **Workflow**: Edit `.github/workflows/iac-scanning.yml`

## 📚 Additional Resources

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Checkov Documentation](https://www.checkov.io/)
- [Terrascan Documentation](https://runterrascan.io/)
- [tfsec Documentation](https://aquasecurity.github.io/tfsec/)

## 🤝 Contributing

This is a security testing project. Contributions welcome for:
- Additional misconfigurations
- More scanning tools
- Improved documentation
- Workflow enhancements

## 📝 License

This project is for educational and security testing purposes only.

## ⚠️ Disclaimer

This infrastructure is intentionally vulnerable and should only be used in isolated sandbox environments for security testing and educational purposes. The authors are not responsible for any misuse or damage caused by deploying this infrastructure.
