import os
import json

def run_bandit():
    print("Running SAST using Bandit")
    os.system("bandit -r PyTodoBackendMonolith -f json -o bandit-report.json")

    with open("bandit-report.json") as f:
        report = json.load(f)

    results = report.get("result", [])
    high = [x for x in results if x["issue_severity"] == "HIGH"]

    if high:
        print("HIGH severity vulnerabilities found!")
        exit(1)
    else:
        print("SAST Passed")

if __name__ == "__main__":
    run_bandit()
