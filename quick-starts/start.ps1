# Called by start.bat; can also be run directly in PowerShell.
$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

function Test-DockerEngine {
    try {
        & docker info --format '{{.ServerVersion}}' *> $null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

try {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        throw "Docker is not installed. See how_to_install_docker.md."
    }

    & docker compose version
    if ($LASTEXITCODE -ne 0) {
        throw "Docker Compose V2 is unavailable. Update Docker Desktop."
    }

    if (-not (Test-DockerEngine)) {
        $desktop = Join-Path $env:ProgramFiles "Docker\Docker\Docker Desktop.exe"
        if (Test-Path -LiteralPath $desktop) {
            Write-Host "Starting Docker Desktop..."
            Start-Process -FilePath $desktop
        }
        Write-Host "Waiting for Docker Engine..."
        for ($i = 0; $i -lt 90; $i++) {
            if (Test-DockerEngine) { break }
            Start-Sleep -Seconds 2
        }
    }
    if (-not (Test-DockerEngine)) {
        throw "Docker Engine is not running. Start Docker Desktop and retry."
    }

    Write-Host "Building (if needed) and starting the course environment..."
    & docker compose up -d --build
    if ($LASTEXITCODE -ne 0) {
        & docker compose logs --tail=30 astronomy-ds
        throw "Could not start the container."
    }

    $probe = @'
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
'@

    Write-Host "Waiting for JupyterLab..."
    $token = ""
    for ($i = 0; $i -lt 90; $i++) {
        $output = @()
        try {
            $output = @(& docker compose exec -T astronomy-ds python -c $probe 2>$null)
        } catch {
            $output = @()
        }
        if ($LASTEXITCODE -eq 0 -and $output.Count -gt 0) {
            $token = [string]($output | Select-Object -Last 1)
            $token = $token.Trim()
        }
        if ($token) { break }
        Start-Sleep -Seconds 2
    }

    if (-not $token) {
        & docker compose logs --tail=40 astronomy-ds
        throw "JupyterLab did not become ready. Check the logs above."
    }

    $portLine = [string](& docker compose port astronomy-ds 8888 | Select-Object -Last 1)
    if ($LASTEXITCODE -ne 0 -or $portLine -notmatch ':(\d+)$') {
        throw "Could not determine JupyterLab's published port."
    }
    $port = $Matches[1]

    $url = "http://127.0.0.1:$port/lab?token=$token"
    Write-Host ""
    Write-Host "JupyterLab is ready: $url"
    Write-Host "Your notebook files are saved in this repository."
    Write-Host "To stop: docker compose down"

    try {
        Start-Process $url
    } catch {
        Write-Warning "Could not open the browser automatically. Open the URL above."
    }
    exit 0
} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
