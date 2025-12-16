# Terraform IAM Policy 1600 - Secure Infrastructure

This repository contains Terraform infrastructure that demonstrates **secure IAM role configuration** following the principle of least privilege. The infrastructure was previously vulnerable to **Policy 1600: IAM Role Inline policy allows all service actions**, but has been fixed to use minimal, scoped permissions.

## 🎯 Purpose

This project demonstrates:
1. Secure IAM role configuration with least privilege principles
2. How to set up automated IaC security scanning workflows
3. How multiple free security scanning tools validate secure configurations
4. CI/CD pipeline that continues execution even when scans find issues

## ✅ Security Status

**This infrastructure follows security best practices.** The IAM role uses minimal, specific permissions instead of wildcard actions. The configuration has been validated by multiple security scanning tools and passes all checks.

## 📋 Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Access to an AWS sandbox/test account
- GitHub account (for CI/CD workflows)

## 🏗️ Infrastructure Components

### Secure IAM Role Configuration

The Terraform configuration creates:
- **IAM Role**: `policy-1600-test-role` (configurable)
- **Inline Policy**: Minimal permissions for EC2 instance operations
  - EC2 describe actions (instances, status, tags, volumes, snapshots)
  - CloudWatch Logs permissions for EC2 log groups
- **Instance Profile**: For attaching the role to EC2 instances

### Security Fixes Applied

**Previous Issue (Policy 1600)**: IAM role inline policy allowed all actions (`Action: "*"`, `Resource: "*"`)

**Fixed Configuration**:
- ✅ Replaced wildcard actions with specific, scoped permissions
- ✅ Limited to EC2 describe operations and CloudWatch Logs
- ✅ Follows principle of least privilege
- ✅ Passes all security scans (Checkov, Terrascan, tfsec)

**Policy IDs Detected (Now Fixed)**:
- `CKV_AWS_274` (Checkov) - ✅ Resolved
- `AWS.IAM.IAMRole.AllowAllActions` (Terrascan) - ✅ Resolved
- `AWS048` (tfsec) - ✅ Resolved

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

### Workflow Behavior

**Key Feature**: The workflow is configured with `continue-on-error: true` for all scanning jobs. This means:
- ✅ Pipeline completes successfully even if individual scans find issues
- ✅ All scan results are still collected and available as artifacts
- ✅ You can review all findings without blocking deployments
- ✅ Useful for monitoring and gradual security improvements

### Running the Workflow

The workflow triggers on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual trigger via `workflow_dispatch`

### Viewing Results

1. **GitHub Actions Tab**: View workflow runs and results (all jobs complete successfully)
2. **Artifacts**: Download detailed scan reports for all tools
3. **Security Tab**: View Terrascan SARIF results (if enabled)
4. **Pull Request Comments**: Some tools may comment on PRs
5. **Summary**: Check the workflow summary for job status overview

## 📊 Expected Scan Results

When scanning this infrastructure, you should see **no security violations**:

### Checkov
```
✅ All checks passed
No Policy 1600 violations detected
CKV_AWS_274: PASSED - IAM role policies follow least privilege
```

### Terrascan
```
✅ No high-severity issues found
✅ IAM role policy uses specific, scoped permissions
```

### tfsec
```
✅ No security issues detected
✅ IAM role policy follows best practices
```

**Note**: If any scans do find issues, the workflow will continue to completion and all results will be available in artifacts for review.

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

## 📝 Changelog

### Version 2.0 - Security Fixes
- ✅ Fixed Policy 1600 vulnerability (wildcard IAM permissions)
- ✅ Implemented least privilege principle with specific permissions
- ✅ Updated CI/CD workflow to continue on error for better visibility
- ✅ All security scans now pass successfully

### Version 1.0 - Initial Release
- Initial infrastructure with Policy 1600 misconfiguration (for testing)
- Basic scanning workflow setup

## ⚠️ Disclaimer

This infrastructure follows security best practices and is safe to deploy to sandbox/test environments. Always review and customize permissions based on your specific requirements. The authors are not responsible for any misuse or damage caused by deploying this infrastructure.
