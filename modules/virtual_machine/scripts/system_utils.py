import psutil

CPU_THRESHOLD = 80
MEM_THRESHOLD = 85
DISK_THRESHOLD = 90

def check_system():
    alerts = []
    try:
      cpu = psutil.cpu_percent()
      if cpu > CPU_THRESHOLD:
          alerts.append(f"High CPU: {cpu}%")
    
      mem = psutil.virtual_memory().percent
      if mem > MEM_THRESHOLD:
         alerts.append(f"High Memory: {mem}%")

      disk = psutil.disk_usage('/').percent
      if disk > DISK_THRESHOLD:
         alerts.append(f"High Disk: {disk}%")
    except Exception as e:
        alerts.append(f"System check error: {e}")
    return alerts 