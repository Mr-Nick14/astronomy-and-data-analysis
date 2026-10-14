#!/usr/bin/env bash
# One-click launcher for Linux and macOS.
set -Eeuo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

fail() {
  printf '\nERROR: %s\n' "$1" >&2
  exit 1
}

if ! command -v docker >/dev/null 2>&1; then
  fail "Docker is not installed. See how_to_install_docker.md."
fi

if ! docker compose version >/dev/null 2>&1; then
  fail "Docker Compose V2 is unavailable. Update Docker."
fi

if ! docker info >/dev/null 2>&1; then
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Starting Docker Desktop..."
    open -a Docker || true
  fi

  echo "Waiting for Docker Engine..."
  for (( i=0; i<90; i++ )); do
    if docker info >/dev/null 2>&1; then
      break
    fi
    sleep 2
  done
fi

docker info >/dev/null 2>&1 ||
  fail "Docker Engine is not running. Start Docker Desktop / Docker Engine and retry."

echo "Building (if needed) and starting the course environment..."
if ! docker compose up -d --build; then
  docker compose logs --tail=30 astronomy-ds || true
  fail "Could not start the container."
fi

# Read Jupyter's *actual* token from inside the container, then verify HTTP.
# Nothing needs to be installed on the host besides Docker.
probe=$(cat <<'PY'
from jupyter_server.serverapp import list_running_servers
from urllib.request import urlopen

for server in list_running_servers():
    if int(server.get("port", 0)) != 8888:
        continue
    token = server.get("token", "")
    if not token:
        continue
    try:
        with urlopen("http://127.0.0.1:8888/lab?token=" + token, timeout=2) as response:
            if response.status < 400:
                print(token)
                break
    except Exception:
        pass
PY
)

echo "Waiting for JupyterLab..."
token=""
for (( i=0; i<90; i++ )); do
  token="$(docker compose exec -T astronomy-ds python -c "$probe" 2>/dev/null | tr -d '\r' | tail -n 1)" || true
  if [[ -n "$token" ]]; then
    break
  fi
  sleep 2
done

if [[ -z "$token" ]]; then
  docker compose logs --tail=40 astronomy-ds || true
  fail "JupyterLab did not become ready. Check the logs above."
fi

port_line="$(docker compose port astronomy-ds 8888)" ||
  fail "Could not find the published JupyterLab port."
host_port="${port_line##*:}"
[[ "$host_port" =~ ^[0-9]+$ ]] ||
  fail "Unexpected port mapping: $port_line"

url="http://127.0.0.1:${host_port}/lab?token=${token}"
echo
echo "JupyterLab is ready: $url"
echo "Your notebook files are saved in this repository."
echo "To stop: docker compose down"

case "$(uname -s)" in
  Darwin)
    open "$url" || echo "Please open the URL above manually."
    ;;
  Linux)
    if command -v xdg-open >/dev/null 2>&1; then
      (xdg-open "$url" >/dev/null 2>&1 || true) &
    else
      echo "Open the URL above in your browser."
    fi
    ;;
  *)
    echo "Open the URL above in your browser."
    ;;
esac
