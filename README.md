## Docker scripts for making jupyter lab + GPU container on Linux

### Usage:
0. Setup `nvidia-container-toolkit` and `docker` into your host Linux. (No CUDA needed in host.)
1. Clone this repo
2. Modify below:
  - `docker-compose.yml`: extra_hosts: type docker host's IP (this is for Dash, see below)
  - `configs/jupyter_server_config.py`: hashed_password: replace to your own
3. `docker compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g)`
3. `docker compose up -d`
4. Access http://localhost:8888/ and type your PW

### Tips
0. Your home folder in host Linux is mounted in `/shared` and `/home/shared` (latter is symlink)
1. [Micromamba](https://github.com/mamba-org/mamba) is installed instead of conda (alias is set).
2. Using [Dash](https://dash.plotly.com/) is tricky but possible, like below:
```
app = JupyterDash(__name__, server_url='http://YOUR-DOCKER-HOST:EXPOSED-PORT/')
app.run_server(mode='jupyterlab', host="0.0.0.0", port=EXPOSED-PORT)
```
