## Docker scripts for making jupyter lab + GPU container on Linux

Note: I changed files a bit when uploading, so please make issue if you encountered an error.

### Usage:
0. Setup `nvidia-container-toolkit` and `docker` into your host Linux. (No CUDA needed in host.)
1. Clone this repo
2. Modify below:
  - `docker-compose.yml`: extra_hosts: type docker host's IP (this is for Dash, see below)
  - `configs/jupyter_server_config.py`: hashed_password: replace to your own
  - `Dockerfile`: timezone: if you living in other than Asia/Tokyo.
3. `docker compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g)`
3. `docker compose up -d`
4. Access http://localhost:8888/ and type your PW

### Tips
0. Your home folder in host Linux is mounted in `/shared` and `/home/shared` (latter is symlink of former)
1. [Micromamba](https://github.com/mamba-org/mamba) is installed instead of conda (conda -> micromamba alias is set).
2. Using [Dash](https://dash.plotly.com/) is tricky but possible, like below:
```
app = JupyterDash(__name__, server_url='http://YOUR-DOCKER-HOST:EXPOSED-PORT/') # YOUR-DOCKER-HOST can be `gateway` if you specified in `docker-compose.yml`
app.run_server(mode='jupyterlab', host="0.0.0.0", port=EXPOSED-PORT)
# port 9001-9004 is exposed as default
```
3. Cache of pip and micromamba is shared to host's ones. If you don't like them, comment out in `docker-compose.yml`.
