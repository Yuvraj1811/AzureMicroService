import subprocess
from alert_utils import log

def is_container_running(name: str) -> bool:
    """Return True if container with exact name is running."""
    rc = subprocess.run(["docker", "ps", "-q", "-f", f"name=^{name}$"], capture_output=True, text=True)
    out = rc.stdout.strip()
    return out != ""

def restart_container(name: str):
    """Attempt to start the container (docker start)."""
    log(f"Container {name} stopped. Restarting...")
    subprocess.run(["docker", "start", name])

