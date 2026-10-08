# How to Install Docker

This guide explains how to install and verify Docker for the Astronomy and Data Analysis course.

After Docker is installed successfully, return to:

[README.md](README.md)

and follow the course startup instructions.

# Windows

## Recommended setup

For most students:

1. Windows 10 or Windows 11, 64-bit;
2. WSL 2;
3. Docker Desktop using the WSL 2 backend.

Docker Desktop includes Docker Engine, the Docker command-line interface, and Docker Compose.

Official documentation:

- [Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Docker Desktop documentation](https://docs.docker.com/desktop/)
- [Microsoft WSL installation guide](https://learn.microsoft.com/windows/wsl/install)

Hardware virtualization must be enabled in BIOS/UEFI.

## Install WSL 2

Open PowerShell as Administrator:

```powershell
wsl --install
```

Restart Windows if requested.

Verify WSL:

```powershell
wsl --version
```

If WSL is already installed:

```powershell
wsl --update
```

## Install Docker Desktop

Download Docker Desktop:

[Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

Run the installer and use the WSL 2 backend.

Start Docker Desktop and wait until Docker reports that the engine is running.

## Verify Docker on Windows

Open a new PowerShell window:

```powershell
docker --version
```

Then:

```powershell
docker compose version
```

Finally:

```powershell
docker run --rm hello-world
```

If all three commands work, Docker is ready.

## Common Windows problems

### `docker` is not recognized

Start Docker Desktop and open a new PowerShell window.

If necessary, restart Windows.

### WSL is outdated

Run:

```powershell
wsl --update
```

Then restart Docker Desktop.

### Virtualization is disabled

Enable hardware virtualization in BIOS/UEFI.

The setting may be called:

```text
Intel VT-x
Intel Virtualization Technology
AMD-V
SVM Mode
```

# macOS

## Install Docker Desktop

Docker Desktop supports both Apple silicon and Intel Macs.

Official documentation:

- [Install Docker Desktop on Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Docker Desktop documentation](https://docs.docker.com/desktop/)

To check your processor architecture:

```bash
uname -m
```

Typical output:

```text
arm64
```

means Apple silicon.

Typical output:

```text
x86_64
```

means Intel.

Download the correct Docker Desktop installer, install it, and start Docker Desktop.

Wait until the Docker engine is running.

## Alternative: Homebrew

If Homebrew is already installed:

```bash
brew install --cask docker
```

Then:

```bash
open -a Docker
```

Homebrew is not required for the course.

## Verify Docker on macOS

Run:

```bash
docker --version
```

Then:

```bash
docker compose version
```

Finally:

```bash
docker run --rm hello-world
```

If all three commands work, Docker is ready.

## Apple silicon note

The course image is based on the official Python Docker image and should normally work natively on Apple silicon.

Do not add:

```yaml
platform: linux/amd64
```

unless there is a specific compatibility problem, because emulation is usually slower than native ARM execution.

# Linux

Docker Engine can be installed directly without Docker Desktop.

Official documentation:

- [Install Docker Engine](https://docs.docker.com/engine/install/)
- [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Debian](https://docs.docker.com/engine/install/debian/)
- [Fedora](https://docs.docker.com/engine/install/fedora/)

The commands below are for Ubuntu and Ubuntu-based distributions.

For another distribution, follow Docker's official instructions for that distribution.

## Ubuntu: install Docker Engine

Remove potentially conflicting packages:

```bash
sudo apt remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc
```

Install required tools:

```bash
sudo apt update
sudo apt install -y ca-certificates curl
```

Create Docker's keyring directory:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Download Docker's signing key:

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
```

Make the key readable:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add Docker's repository:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update package metadata:

```bash
sudo apt update
```

Install Docker Engine, Buildx, and Docker Compose:

```bash
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

If these commands differ from the current official Docker documentation, use the current official instructions:

[Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

## Verify Docker on Linux

Run:

```bash
sudo docker run --rm hello-world
```

Check versions:

```bash
docker --version
```

```bash
docker compose version
```

## Run Docker without `sudo`

Some Linux systems require `sudo docker ...`.

For a development computer, you can add your user to the `docker` group.

Create the group if necessary:

```bash
sudo groupadd docker
```

Add your user:

```bash
sudo usermod -aG docker "$USER"
```

Log out and log back in.

Alternatively:

```bash
newgrp docker
```

Test:

```bash
docker run --rm hello-world
```

Important: membership in the `docker` group effectively grants root-level control over the machine.

Docker documentation:

[Linux post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/)

# Final verification

Regardless of operating system, these commands should work:

```bash
docker --version
```

```bash
docker compose version
```

```bash
docker run --rm hello-world
```

Once they work, continue with:

[README.md](README.md)

The first course command will be:

```bash
docker compose build
```
