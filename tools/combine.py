import json

R = "reports"


def load(path, default):
    try:
        with open(path, encoding="utf-8-sig") as f:
            text = f.read().strip()
            return json.loads(text) if text else default
    except FileNotFoundError:
        return default


data = {
    "semgrep": load(R + "/semgrep.json", {"results": []}),
    "gitleaks": load(R + "/gitleaks.json", []),
    "trivy": load(R + "/trivy.json", {"Results": []}),
}

with open(R + "/input.json", "w", encoding="utf-8") as f:
    json.dump(data, f)

print("input.json created")
