import time
import logging
import logging.handlers
import os
from alert_utils import send_alert, log as alert_log
from system_utils import check_system
from docker_utils import is_container_running, restart_container


#----Log Setup ----
LOG_FILE = "/var/log/container-monitor.log"
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
logger = logging.getLogger("container-monitor")
logger.setLevel(logging.INFO)
handler = logging.handlers.RotatingFileHandler(LOG_FILE, maxBytes=5*1024*1024, backupCount=3)
formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)

def app_log(msg):
   logger.info(msg)
   print(msg)

CONTAINER_NAME = "${container_name}"
CHECK_INTERVAL = 15

app_log("Monitoring service started...")

while True:
    alerts = []

    try:
      if not is_container_running(CONTAINER_NAME):
         restart_container(CONTAINER_NAME)
         alerts.append(f"Container {CONTAINER_NAME} was down and restarted.")
    except Exception as e:
         msg = f"Error while checking/restarting container: {e}"
         app_log(msg)
         alerts.append(msg)

    try:
      sys_alerts = check_system()
      if sys_alerts:
         for a in sys_alerts:
            app_log(a)
      alerts.extend(sys_alerts)
    except Exception as e:
        msg = f"Error while running system checks: {e}"
        app_log(msg)
        alerts.append(msg)


    for alert_msg in alerts:
        
        app_log(f"Sending alert: {alert_msg}")
        send_alert(alert_msg)

    time.sleep(CHECK_INTERVAL)



