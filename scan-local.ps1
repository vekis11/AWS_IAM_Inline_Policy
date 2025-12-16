# Local IaC Security Scanning Script for Windows PowerShell
# Run this script to test security scans locally before pushing to GitHub

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "IaC Security Scanning - Local Execution" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if a tool is installed
function Test-Tool {
    param([string]$ToolName)
    
    $tool = Get-Command $ToolName -ErrorAction SilentlyContinue
    if ($tool) {
        Write-Host "✓ $ToolName is installed" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ $ToolName is not installed" -ForegroundColor Red
        return $false
    }
}

Write-Host "Checking required tools..." -ForegroundColor Yellow
Write-Host ""

$toolsAvailable = @{
    terraform = Test-Tool "terraform"
    checkov = Test-Tool "checkov"
    terrascan = Test-Tool "terrascan"
    tfsec = Test-Tool "tfsec"
    trufflehog = Test-Tool "trufflehog"
    gitleaks = Test-Tool "gitleaks"
}

$missingTools = ($toolsAvailable.Values | Where-Object { $_ -eq $false }).Count

if ($missingTools -gt 0) {
    Write-Host ""
    Write-Host "Some tools are missing. Install them with:" -ForegroundColor Yellow
    Write-Host "  pip install checkov"
    Write-Host "  pip install truffleHog"
    Write-Host "  choco install terraform terrascan tfsec gitleaks"
    Write-Host ""
    $continue = Read-Host "Continue with available tools? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "1. Terraform Validation" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
if ($toolsAvailable.terraform) {
    terraform init -upgrade
    terraform validate
    terraform fmt -check
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Terraform files need formatting" -ForegroundColor Yellow
    }
} else {
    Write-Host "Skipping Terraform (not installed)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "2. Checkov Scan" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
if ($toolsAvailable.checkov) {
    checkov -d . --framework terraform --output cli --download-external-modules true
} else {
    Write-Host "Skipping Checkov (not installed)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "3. Terrascan Scan" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
if ($toolsAvailable.terrascan) {
    terrascan scan -t terraform -i terraform --verbose
} else {
    Write-Host "Skipping Terrascan (not installed)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "4. tfsec Scan" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
if ($toolsAvailable.tfsec) {
    tfsec .
} else {
    Write-Host "Skipping tfsec (not installed)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "5. Secrets Scanning - TruffleHog" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
if ($toolsAvailable.trufflehog) {
    trufflehog filesystem . --json
} else {
    Write-Host "Skipping TruffleHog (not installed)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "6. Secrets Scanning - Gitleaks" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
if ($toolsAvailable.gitleaks) {
    gitleaks detect --source . --verbose
} else {
    Write-Host "Skipping Gitleaks (not installed)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Scanning Complete!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Review the results above for security issues." -ForegroundColor Yellow
Write-Host "Expected findings:" -ForegroundColor Yellow
Write-Host "  - Policy 1600: IAM role with inline policy allowing all actions" -ForegroundColor Yellow
Write-Host ""
