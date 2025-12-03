import json
import os
import pandas as pd
from jinja2 import Template

artifact_dir = os.environ.get('BUILD_ARTIFACTSTAGINGDIRECTORY', '.')

tflint_file = os.path.join(artifact_dir, "tflint-report.json")
trivy_file = os.path.join(artifact_dir, "trivy-report.json")

issues = []

# Read TFLint
if os.path.exists(tflint_file):
    with open(tflint_file) as f:
        data = json.load(f)
        for issue in data.get("issues", []):
            issues.append({
                "Tool": "TFLint",
                "File": issue.get("range", {}).get("filename", ""),
                "Line": issue.get("range", {}).get("start", {}).get("line", ""),
                "Type": issue.get("rule", ""),
                "Message": issue.get("message", "")
            })

# Read Trivy
if os.path.exists(trivy_file):
    with open(trivy_file) as f:
        data = json.load(f)
        for result in data.get("Results", []):
            for vuln in result.get("Misconfigurations", []):
                issues.append({
                    "Tool": "Trivy",
                    "File": result.get("Target", ""),
                    "Line": vuln.get("StartLine", ""),
                    "Type": vuln.get("ID", ""),
                    "Message": vuln.get("Title", "")
                })

# HTML Template
html_template = """
<!DOCTYPE html>
<html>
<head>
<title>Security Report</title>
<style>
body { font-family: Arial; }
table { width: 100%; border-collapse: collapse; }
th, td { border: 1px solid #ccc; padding: 8px; }
th { background-color: #eee; }
.TFLint { background-color: #ffdddd; }
.Trivy { background-color: #ddffdd; }
</style>
</head>
<body>
<h2>Consolidated Security Report</h2>
<table>
<tr><th>Tool</th><th>File</th><th>Line</th><th>Type</th><th>Message</th></tr>
{% for row in rows %}
<tr class="{{row.Tool}}">
<td>{{row.Tool}}</td>
<td>{{row.File}}</td>
<td>{{row.Line}}</td>
<td>{{row.Type}}</td>
<td>{{row.Message}}</td>
</tr>
{% endfor %}
</table>
</body>
</html>
"""

template = Template(html_template)
html_content = template.render(rows=issues)

output_file = os.path.join(artifact_dir, "Consolidated_Security_Report.html")
with open(output_file, "w") as f:
    f.write(html_content)

print(f"Generated: {output_file}")
