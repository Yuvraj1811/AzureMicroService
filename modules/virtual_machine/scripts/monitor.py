import time
import subprocess

container_name = "${container_name}"

def is_container_running():
    result = subprocess.run(["docker", "ps", "-q", "-f", f"name={container_name}"], capture_output=True, text=True)
    return result.stdout.strip() != ""

def restart_container():
    print(f"Container {container_name} stopped. Restarting...")
    subprocess.run(["docker", "start", container_name])

while True:
    if not is_container_running():
        restart_container()
    time.sleep(10)