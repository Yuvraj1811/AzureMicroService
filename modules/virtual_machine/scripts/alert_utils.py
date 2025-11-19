import time
import smtplib
import requests
from email.mime.text import MIMEText

LOG_FILE = "/var/log/container-monitor.log"
SLACK_WEBHOOK = ""
EMAIL_TO = ""
EMAIL_FROM = ""
SMTP_USER = ""
SMTP_PASS = ""

ALERT_COOLDOWN = 300
last_alert = 0

def log(msg: str):
 try:
    with open(LOG_FILE, "a") as f:
        f.write(f"[{time.ctime()}] {msg}\n")
 except Exception:
    pass
print(msg)

def send_slack(msg: str):
    if not SLACK_WEBHOOK:
        return
    try:
        requests.post(SLACK_WEBHOOK, json={"text": msg}, timeout=10)
        log("Sent Slack alert")

    except Exception as e:
        log(f"Slack error: {e}")

def send_email(msg: str):
    if not EMAIL_TO:
        return
    try:
      m = MIMEText(msg)
      m['SUBJECT'] = "VM Alert"
      m['FROM'] = EMAIL_FROM
      m['TO'] = EMAIL_TO

      s = smtplib.SMTP("smtp.gmail.com", 587)
      s.starttls()
      s.login(SMTP_USER, SMTP_PASS)
      s.sendmail(EMAIL_FROM, EMAIL_TO, m.as_string())
      s.quit()
      log("Sent email alert")
    except Exception as e:
      log(f"Email error: {e}")

def send_alert(message: str):
    global last_alert
    now = time.time()
    if now - last_alert < ALERT_COOLDOWN:
        log("Skipping alert due to cooldown")
        return
    log("ALERT: " + message)
    send_slack(message)
    send_email(message)
    last_alert = now