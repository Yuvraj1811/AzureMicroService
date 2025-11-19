import time
from alert_utils import send_alert, log
from system_utils import check_system
from docker_utils import is_container_running, restart_container

CONTAINER_NAME = "${container_name}"
CHECK_INTERVAL = 15

log("Monitoring service started...")

while True:
    alerts = []

    try:
      if not is_container_running(CONTAINER_NAME):
         restart_container(CONTAINER_NAME)
         alerts.append(f"Container {CONTAINER_NAME} was down and restarted.")
    except Exception as e:
         log(f"Error while checking/restarting container: {e}")
         alerts.append(f"Error while checking/restarting container: {e}")

    try:
      alerts.extend(check_system())
    except Exception as e:
        log(f"Error while running system checks: {e}")
        alerts.append(f"Error while running system checks: {e}")


    for alert in alerts:
        send_alert(alert)

    time.sleep(CHECK_INTERVAL)



