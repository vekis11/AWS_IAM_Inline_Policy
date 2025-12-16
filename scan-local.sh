#!/bin/bash
# Local IaC Security Scanning Script
# Run this script to test security scans locally before pushing to GitHub

set -e

echo "=========================================="
echo "IaC Security Scanning - Local Execution"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if tools are installed
check_tool() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is not installed"
        return 1
    fi
}

echo "Checking required tools..."
echo ""

MISSING_TOOLS=0

check_tool terraform || MISSING_TOOLS=1
check_tool checkov || MISSING_TOOLS=1
check_tool terrascan || MISSING_TOOLS=1
check_tool tfsec || MISSING_TOOLS=1
check_tool trufflehog || MISSING_TOOLS=1
check_tool gitleaks || MISSING_TOOLS=1

if [ $MISSING_TOOLS -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}Some tools are missing. Install them with:${NC}"
    echo "  pip install checkov"
    echo "  go install github.com/tenable/terrascan/cmd/terrascan@latest"
    echo "  go install github.com/aquasecurity/tfsec/v2/cmd/tfsec@latest"
    echo "  pip install truffleHog"
    echo "  go install github.com/gitleaks/gitleaks/v8@latest"
    echo ""
    read -p "Continue with available tools? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "1. Terraform Validation"
echo "=========================================="
terraform init -upgrade
terraform validate
terraform fmt -check || echo -e "${YELLOW}Warning: Terraform files need formatting${NC}"
echo ""

echo "=========================================="
echo "2. Checkov Scan"
echo "=========================================="
if command -v checkov &> /dev/null; then
    checkov -d . --framework terraform --output cli --download-external-modules true
    echo ""
else
    echo -e "${YELLOW}Skipping Checkov (not installed)${NC}"
    echo ""
fi

echo "=========================================="
echo "3. Terrascan Scan"
echo "=========================================="
if command -v terrascan &> /dev/null; then
    terrascan scan -t terraform -i terraform --verbose
    echo ""
else
    echo -e "${YELLOW}Skipping Terrascan (not installed)${NC}"
    echo ""
fi

echo "=========================================="
echo "4. tfsec Scan"
echo "=========================================="
if command -v tfsec &> /dev/null; then
    tfsec .
    echo ""
else
    echo -e "${YELLOW}Skipping tfsec (not installed)${NC}"
    echo ""
fi

echo "=========================================="
echo "5. Secrets Scanning - TruffleHog"
echo "=========================================="
if command -v trufflehog &> /dev/null; then
    trufflehog filesystem . --json || true
    echo ""
else
    echo -e "${YELLOW}Skipping TruffleHog (not installed)${NC}"
    echo ""
fi

echo "=========================================="
echo "6. Secrets Scanning - Gitleaks"
echo "=========================================="
if command -v gitleaks &> /dev/null; then
    gitleaks detect --source . --verbose || true
    echo ""
else
    echo -e "${YELLOW}Skipping Gitleaks (not installed)${NC}"
    echo ""
fi

echo "=========================================="
echo "Scanning Complete!"
echo "=========================================="
echo ""
echo "Review the results above for security issues."
echo "Expected findings:"
echo "  - Policy 1600: IAM role with inline policy allowing all actions"
echo ""
