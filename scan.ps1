$ErrorActionPreference = "Continue"
New-Item -ItemType Directory -Force -Path reports | Out-Null
Remove-Item reports\*.json -ErrorAction SilentlyContinue

docker run --rm -v "${PWD}\src:/src" -v "${PWD}\rules:/rules" -v "${PWD}\reports:/reports" semgrep/semgrep semgrep scan --config /rules/custom.yml --json --output /reports/semgrep.json /src
docker run --rm -v "${PWD}\src:/src" -v "${PWD}\reports:/reports" zricethezav/gitleaks:latest detect --source /src --no-git --report-format json --report-path /reports/gitleaks.json --exit-code 0
docker run --rm -v "${PWD}\src:/src" -v "${PWD}\reports:/reports" aquasec/trivy:latest fs --scanners vuln --severity HIGH,CRITICAL --format json --output /reports/trivy.json /src

python tools\combine.py
.\tools\opa.exe eval --format pretty -i reports\input.json -d policy\security.rego "data.security.deny"
$count = .\tools\opa.exe eval --format raw -i reports\input.json -d policy\security.rego "count(data.security.deny)"
if ([int]$count -gt 0) { Write-Host "GATE: FAIL ($count findings) - BLOCKED" -ForegroundColor Red; exit 1 }
Write-Host "GATE: PASS" -ForegroundColor Green
exit 0
