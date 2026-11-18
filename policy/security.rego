package security

import rego.v1

deny contains msg if {
some r in input.semgrep.results
r.extra.severity == "ERROR"
msg := sprintf("SAST: %s at %s:%d", [r.check_id, r.path, r.start.line])
}

deny contains msg if {
some f in input.gitleaks
msg := sprintf("SECRET: %s in %s:%d", [f.RuleID, f.File, f.StartLine])
}

deny contains msg if {
some res in input.trivy.Results
some v in res.Vulnerabilities
v.Severity in {"HIGH", "CRITICAL"}
msg := sprintf("DEPENDENCY: %s %s %s (%s)", [v.VulnerabilityID, v.PkgName, v.InstalledVersion, v.Severity])
}
