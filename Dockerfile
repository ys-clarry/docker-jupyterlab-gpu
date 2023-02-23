# ---- BASE IMAGE ---- #
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
USER root

# ---- USER ADD ---- #
ARG UID
ENV UID=${UID}
ARG GID
ENV GID=${GID}
RUN groupadd -f -g $GID jupyter
RUN useradd jupyter -m -u $UID -g $GID
RUN mkdir /shared && chown jupyter:jupyter /shared

# ---- SOFTWARES ---- #

# > APT < #
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt -y install tzdata lsb-release \
                   htop iproute2
                   cmake build-essential curl git \
                   vim less \
                   python3 python3-distutils python3-dev \
                   ffmpeg feh

# > NODEJS PREPARE < #
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt -y install nodejs

# > PIP < #
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py

# ---- TIMEZONE ---- #
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ---- USER ENV SETUP ---- #
USER jupyter
WORKDIR /home/jupyter
RUN ln -s /shared /home/jupyter/shared
ENV PATH /home/jupyter/.local/bin:$PATH

# > DEFAULT CONFIGS < #
COPY configs/bash_aliases .bash_aliases
COPY configs/mambarc .mambarc
RUN mkdir .jupyter
COPY configs/jupyter_server_config.py .jupyter
RUN chown -R jupyter:jupyter .bash_aliases .mambarc .jupyter/

# ---- JUPYTER SETUP ---- #
RUN pip install --user --upgrade \
    pip \
    setuptools \
    notebook \
    ipywidgets \
    jupyterlab \
    jupyter-dash \
    jupyter-resource-usage \
    ipylab \
    matplotlib \
    tqdm \
    pandas \
    nbformat \
    joblib

# ---- FOR DASH ---- #
RUN jupyter lab build

# ---- MICROMAMBA ---- #
RUN curl -O micro.mamba.pm/install.sh && bash install.sh && rm install.sh

# ---- PORTS ---- #
# > FOR JUPYTER < #
EXPOSE 8888
# > FOR TEMPORARY USES < #
EXPOSE 9000 9001 9002 9003 9004 9005 9006 9007 9008 9009 9010

# --- RUN ---- #
CMD ["jupyter", "lab", "--port", "8888"] # BY DEFAULT; see docker-compose.yml
