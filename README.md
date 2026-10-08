# Astronomy and Data Analysis Course

Repository containing programming and machine learning assignments from the Astronomy and Data Analysis course at CTE School (Школа ЦПМ).

The course environment runs inside Docker so that every student uses the same Python version and the same scientific libraries.

You do not need to install Python, NumPy, Polars, Astropy, scikit-learn, Jupyter, or the other course libraries directly on your computer.

If Docker is not installed yet, follow:

[How to install Docker](how_to_install_docker.md)

## Project structure

The repository should look approximately like this:

```text
astronomy-course/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .dockerignore
├── README.md
├── how_to_install_docker.md
├── 01_python_numpy_basics/
├── ...
├── data/
├── src/
└── output/
```

Run all commands below from the directory containing `docker-compose.yml`.

## 1. Open the repository

Open Terminal on macOS/Linux or PowerShell on Windows and move to the project directory.

macOS / Linux:

```bash
cd path/to/astronomy-course
```

Windows PowerShell:

```powershell
cd C:\path\to\astronomy-course
```

## 2. Build the course environment

You normally need to do this only:

- the first time you use the repository;
- after `Dockerfile` changes;
- after `requirements.txt` changes;
- when the teacher asks you to rebuild the environment.

Run:

```bash
docker compose build
```

The first build can take some time because Docker needs to download Python and install the scientific libraries.

## 3. Start JupyterLab

Run:

```bash
docker compose up
```

JupyterLab will start inside the Docker container.

In the terminal output, look for a URL similar to:

```text
http://127.0.0.1:8888/lab?token=...
```

Open that URL in your browser.

You can also try:

```text
http://localhost:8888
```

If Jupyter asks for a token, copy it from the terminal output.

Keep the terminal window open while you are working.

## 4. Open and run a notebook

In JupyterLab, open the required `.ipynb` file.

Run a cell with:

```text
Shift + Enter
```

The code is executed by Python inside the Docker container, where all course libraries are already installed.

Your repository is mounted into the container as `/workspace`, so notebooks and other files are saved directly to your computer.

For example, if your repository contains:

```text
astronomy-course/
├── 01_python_numpy_basics/
│   └── homework.ipynb
└── data/
    └── planets.csv
```

the container sees approximately:

```text
/workspace/
├── 01_python_numpy_basics/
│   └── homework.ipynb
└── data/
    └── planets.csv
```

## 5. Stop the environment

If `docker compose up` is running in the foreground, press:

```text
Ctrl + C
```

Then run:

```bash
docker compose down
```

Your notebooks and data remain in the repository directory.

## Normal workflow for every lesson

After the first setup, the usual workflow is:

```bash
cd path/to/astronomy-course
docker compose up
```

Then open:

```text
http://localhost:8888
```

Work with the notebooks in JupyterLab.

When finished:

```text
Ctrl + C
```

and:

```bash
docker compose down
```

You do not need to rebuild the image before every lesson.

## Start Docker in the background

If you do not want Jupyter logs to occupy the current terminal:

```bash
docker compose up -d
```

View logs:

```bash
docker compose logs -f astronomy-ds
```

Stop:

```bash
docker compose down
```

## Rebuild after dependency changes

If `requirements.txt` or `Dockerfile` has changed:

```bash
docker compose build
docker compose up
```

For a completely clean rebuild:

```bash
docker compose down
docker compose build --no-cache
docker compose up
```

## Check that the environment works

With the container running:

```bash
docker compose exec astronomy-ds python -c "import numpy, scipy, polars, matplotlib, sklearn, astropy; print('Environment OK')"
```

Expected output:

```text
Environment OK
```

## Useful commands

Container status:

```bash
docker compose ps
```

Jupyter logs:

```bash
docker compose logs -f astronomy-ds
```

Open a shell inside the container:

```bash
docker compose exec astronomy-ds bash
```

Run tests:

```bash
docker compose exec astronomy-ds pytest
```

Check Python code:

```bash
docker compose exec astronomy-ds ruff check .
```

Format Python code:

```bash
docker compose exec astronomy-ds ruff format .
```

## If JupyterLab does not open

Check these points:

1. Docker Desktop or Docker Engine is running.
2. You are in the directory containing `docker-compose.yml`.
3. `docker compose build` completed successfully.
4. The container is running:

```bash
docker compose ps
```

5. Check the logs:

```bash
docker compose logs astronomy-ds
```

6. If port `8888` is already occupied, change the port mapping in `docker-compose.yml`, for example:

```yaml
ports:
  - "8889:8888"
```

Then restart:

```bash
docker compose down
docker compose up
```

and open:

```text
http://localhost:8889
```

## Docker installation

If Docker is not installed or `docker` / `docker compose` commands do not work, see:

[How to install Docker on Windows, macOS, and Linux](how_to_install_docker.md)
