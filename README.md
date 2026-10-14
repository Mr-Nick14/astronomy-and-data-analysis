# Astronomy and Data Analysis Course

This repository contains programming, data analysis, and machine learning assignments for the **Astronomy and Data Analysis** course at CTE School (Школа ЦПМ).

The course uses **Docker** to provide the same Python environment and scientific libraries on Windows, macOS, and Linux. You do not need to install Python, JupyterLab, NumPy, Polars, Astropy, scikit-learn, or other course libraries on your computer.

## Getting started

### 1. Install Docker

Install Docker for your operating system using the [Docker installation guide](how_to_install_docker.md).

Make sure Docker Desktop (Windows/macOS) or Docker Engine (Linux) is running before you start the course.

### 2. Download the repository

You can clone the repository with Git:

```bash
git clone https://github.com/Mr-Nick14/astronomy-and-data-analysis.git
```

Alternatively, select **Code → Download ZIP** on GitHub and extract the archive to a convenient folder.

### 3. Start JupyterLab

Open the `quick_start` folder and launch the file for your operating system:

| Operating system | How to start |
| --- | --- |
| Windows | Double-click `start.bat`. |
| macOS | Double-click `start.command`. |
| Linux | Open a terminal in the repository root and run `bash quick_start/start.sh`. |

The launcher starts the Docker container, waits until JupyterLab is ready, and opens it in your default browser. On the first run, Docker also builds the course environment and downloads the required libraries.

For detailed instructions, see the [Quick Start guide](quick_start/QUICK_START.md).

### 4. Work with notebooks

In JupyterLab, open the required `.ipynb` file and run cells using **Shift + Enter**.

All code runs inside the Docker container with the course libraries already installed. Changes to notebooks and other files are saved in your local repository folder, so your work is preserved after the container stops.

### 5. Stop the environment

Open a terminal in the repository root (the folder containing `docker-compose.yml`) and run:

```bash
docker compose down
```

This stops the course container without deleting your notebooks or project files. To start working again, use the same launcher.

## Project structure

```text
astronomy-and-data-analysis/
├── 01_python_numpy_basics/       # Lesson materials and notebooks
├── quick_start/                 # One-click launchers and instructions
│   ├── QUICK_START.md
│   ├── start.bat                 # Windows launcher
│   ├── start.ps1                # Windows PowerShell script
│   ├── start.command            # macOS launcher
│   └── start.sh                 # macOS / Linux script
├── Dockerfile                   # Course Docker image
├── docker-compose.yml          # Container configuration
├── requirements.txt            # Python dependencies
├── how_to_install_docker.md    # Docker installation guide
└── README.md
```

Additional lesson folders will be added as the course progresses.

The repository is mounted inside the container at `/workspace`. For example, a notebook located in `01_python_numpy_basics/` on your computer is available at `/workspace/01_python_numpy_basics/` in JupyterLab.

## Manual Docker commands

The launchers are the recommended way to start the course. The commands below are useful if you prefer to manage the environment yourself.

**Run all commands from the repository root**, where `docker-compose.yml` is located.

### Build and start

```bash
docker compose up -d --build
```

To find the JupyterLab URL and access token, check the logs:

```bash
docker compose logs astronomy-ds
```

Open the JupyterLab URL shown in the logs. The default local port is `8888`.

### Check the environment

Check container status:

```bash
docker compose ps
```

Verify that the main course libraries can be imported:

```bash
docker compose exec astronomy-ds python -c "import numpy, scipy, polars, matplotlib, sklearn, astropy; print('Environment OK')"
```

### Useful commands

| Action | Command |
| --- | --- |
| View recent logs | `docker compose logs --tail=50 astronomy-ds` |
| Follow logs | `docker compose logs -f astronomy-ds` |
| Open a shell inside the container | `docker compose exec astronomy-ds bash` |
| Run tests | `docker compose exec astronomy-ds pytest` |
| Check Python code | `docker compose exec astronomy-ds ruff check .` |
| Format Python code | `docker compose exec astronomy-ds ruff format .` |
| Stop and remove the container | `docker compose down` |

### Rebuild the environment

The launcher normally reuses Docker's build cache. After changes to `Dockerfile` or `requirements.txt`, you can explicitly rebuild the environment:

```bash
docker compose up -d --build
```

To rebuild without using the cache:

```bash
docker compose build --no-cache
docker compose up -d
```

## Troubleshooting

**Docker is not installed or running.** Follow the [Docker installation guide](how_to_install_docker.md), start Docker, and run the launcher again.

**The browser does not open automatically.** Copy the JupyterLab URL printed in the launcher window and open it in your browser. Include the token in the URL.

**JupyterLab fails to start.** Check the logs from the repository root:

```bash
docker compose logs --tail=50 astronomy-ds
```

**Port `8888` is already in use.** Change the published port in `docker-compose.yml`, for example:

```yaml
ports:
  - "127.0.0.1:8889:8888"
```

Then restart the environment. The launchers detect the published port automatically.

For more help with the launchers, see [Quick Start](quick_start/QUICK_START.md).