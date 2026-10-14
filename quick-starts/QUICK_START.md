# Quick Start: Astronomy and Data Analysis

This guide explains how to start the course environment with a single launcher.

The course runs in Docker and opens **JupyterLab** in your browser. You do not need to install Python, Jupyter, or any scientific libraries on your computer.

## 1. Before you start

1. Install Docker for your operating system: [How to install Docker](how_to_install_docker.md).
2. Start Docker Desktop (Windows/macOS) or make sure Docker Engine is running (Linux). You can check health using '''docker ps'''.
3. Download or clone the course repository and open its folder.

You only need to install Docker once. An internet connection is required for the initial image build.

## 2. Start the course

Choose the instructions for your operating system.

### Windows

Double-click **`start.bat`** in the project folder.

A terminal window will appear. The script starts the Docker container and opens JupyterLab in your default browser when it is ready.

### macOS

Double-click **`start.command`** in the project folder.

If macOS reports that the file cannot be executed, open Terminal in the project folder and run:

```bash
chmod +x start.command start.sh
```

Then open `start.command` again. If macOS blocks the downloaded script for security reasons, review the warning in **System Settings → Privacy & Security** and allow it only if you trust the file.

### Linux

Open a terminal in the project folder and run:

```bash
bash start.sh
```

The script starts the Docker container and attempts to open JupyterLab in your default browser.

## 3. Work in JupyterLab

When the environment is ready, your browser will open JupyterLab automatically.

Open the required `.ipynb` notebook and execute a cell with **Shift + Enter**.

All code runs inside the Docker container, using the course's Python environment and installed libraries. Notebooks and other project files are saved directly in your local repository folder, so your work remains available after the container stops.

The first launch may take longer because Docker needs to build the image and install the dependencies. Later launches reuse Docker's build cache.

## 4. Stop the course environment

When you finish working, open a terminal in the project folder and run:

```bash
docker compose down
```

This stops and removes the course container without deleting your notebooks or other files in the project folder.

To work again, use the same launcher from **Section 2**.

## 5. Troubleshooting

### Docker is not running

Start Docker Desktop or Docker Engine and run the launcher again. If Docker is not installed, follow [How to install Docker](how_to_install_docker.md).

### The browser does not open

The launcher prints a JupyterLab URL in the terminal. Copy that URL, including its token, and open it in your browser.

### JupyterLab does not start

Check the container logs from the project folder:

```bash
docker compose logs --tail=50 astronomy-ds
```

If port `8888` is already in use or the container reports another error, see the troubleshooting section in [README.md](README.md).

For additional commands and a detailed explanation of the Docker environment, see [README.md](README.md).
