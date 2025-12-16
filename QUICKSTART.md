# Quick Start Guide

## 🚀 Quick Deployment Steps

### 1. Prerequisites Setup

```bash
# Install Terraform (if not already installed)
# Windows: choco install terraform
# macOS: brew install terraform
# Linux: Download from https://www.terraform.io/downloads

# Configure AWS credentials
aws configure --profile sandbox
# Or set environment variables:
# export AWS_ACCESS_KEY_ID=your-key
# export AWS_SECRET_ACCESS_KEY=your-secret
# export AWS_DEFAULT_REGION=us-east-1
```

### 2. Deploy Infrastructure

```bash
# Navigate to project directory
cd terraform-iam-policy-1600

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Deploy (WARNING: Creates vulnerable IAM role)
terraform apply
```

### 3. Run Local Security Scans

#### Option A: Using the Script (Recommended)

**Linux/macOS:**
```bash
chmod +x scan-local.sh
./scan-local.sh
```

**Windows PowerShell:**
```powershell
.\scan-local.ps1
```

#### Option B: Manual Scanning

```bash
# Checkov
checkov -d . --framework terraform

# Terrascan
terrascan scan -t terraform -i terraform

# tfsec
tfsec .

# Secrets scanning
trufflehog filesystem .
gitleaks detect --source .
```

### 4. Set Up GitHub Actions (Optional)

1. Push this repository to GitHub
2. The workflow will automatically run on push/PR
3. View results in the Actions tab

### 5. Clean Up

```bash
# Destroy all resources
terraform destroy
```

## 🔍 What to Expect

### Terraform Output
- Creates IAM role: `policy-1600-test-role`
- Creates inline policy with `Action: "*"` and `Resource: "*"`

### Security Scan Results

All scanners should detect:
- **Checkov**: `CKV_AWS_274` - IAM role policy allows full administrative privileges
- **Terrascan**: `AWS.IAM.IAMRole.AllowAllActions` - HIGH severity
- **tfsec**: `AWS048` - IAM role policy allows wildcard actions

## 📋 Troubleshooting

### AWS Credentials Issues
```bash
# Verify credentials
aws sts get-caller-identity --profile sandbox

# Or with environment variables
export AWS_PROFILE=sandbox
aws sts get-caller-identity
```

### Terraform Issues
```bash
# Clean and reinitialize
rm -rf .terraform
terraform init
```

### Scanning Tool Issues
- Ensure tools are in your PATH
- Check tool versions are up to date
- Review tool-specific documentation

## 🎯 Next Steps

1. Review scan results and understand the findings
2. Modify the Terraform to fix the misconfiguration
3. Re-run scans to verify the fix
4. Explore other security policies and misconfigurations
