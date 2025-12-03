import json
import os
import pandas as pd
from jinja2 import Template

# --------------------------
# Paths to your reports
# --------------------------
artifact_dir = artifact_dir = os.environ.get('BUILD_ARTIFACTSTAGINGDIRECTORY', '.')
tflint_file = os.path.join(artifact_dir, "tflint-report.json")
tfsec_file = os.path.join(artifact_dir, "tfsec-report.json")
checkov_file = os.path.join(artifact_dir, "checkov-report.json")

# --------------------------
# Read TFLint report
# --------------------------
tflint_data = []
if os.path.exists(tflint_file):
    with open(tflint_file) as f:
        data = json.load(f)
        for issue in data.get('issues', []):
            tflint_data.append({
                "Tool": "TFLint",
                "File": issue.get("file", ""),
                "Line": issue.get("line", ""),
                "Type": issue.get("type", ""),
                "Message": issue.get("message", "")
            })

# --------------------------
# Read TFsec report
# --------------------------
tfsec_data = []
if os.path.exists(tfsec_file):
    with open(tfsec_file) as f:
        data = json.load(f)
        for issue in data.get('results', []):
            tfsec_data.append({
                "Tool": "TFsec",
                "File": issue.get('file', ''),
                "Line": issue.get('start_line', ''),
                "Type": issue.get('rule_id', ''),
                "Message": issue.get('description', '')
            })

# --------------------------
# Read Checkov report
# --------------------------
checkov_data = []
if os.path.exists(checkov_file):
    with open(checkov_file) as f:
        data = json.load(f)
        for check in data.get('results', {}).get('failed_checks', []):
            checkov_data.append({
                "Tool": "Checkov",
                "File": check.get('file_path', ''),
                "Line": check.get('file_line_range', [0])[0],
                "Type": check.get('check_id', ''),
                "Message": check.get('check_name', '')
            })

# --------------------------
# Combine all
# --------------------------
all_issues = tflint_data + tfsec_data + checkov_data
df = pd.DataFrame(all_issues)

# --------------------------
# Generate HTML using Jinja2
# --------------------------
html_template = """
<!DOCTYPE html>
<html>
<head>
    <title>Security Report</title>
    <style>
        body { font-family: Arial; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
        tr:hover { background-color: #f5f5f5; }
        .TFLint { background-color: #ffdddd; }
        .TFsec { background-color: #ddffdd; }
        .Checkov { background-color: #ddddff; }
    </style>
</head>
<body>
    <h2>Consolidated Security Report</h2>
    <table>
        <tr>
            <th>Tool</th>
            <th>File</th>
            <th>Line</th>
            <th>Type</th>
            <th>Message</th>
        </tr>
        {% for row in rows %}
        <tr class="{{ row.Tool }}">
            <td>{{ row.Tool }}</td>
            <td>{{ row.File }}</td>
            <td>{{ row.Line }}</td>
            <td>{{ row.Type }}</td>
            <td>{{ row.Message }}</td>
        </tr>
        {% endfor %}
    </table>
</body>
</html>
"""

template = Template(html_template)
html_content = template.render(rows=all_issues)

# Save HTML file
html_file = os.path.join(artifact_dir, "Consolidated_Security_Report.html")
with open(html_file, "w") as f:
    f.write(html_content)

print(f"Report generated: {html_file}")
