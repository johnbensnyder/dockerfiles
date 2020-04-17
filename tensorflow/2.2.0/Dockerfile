FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04

ARG PYTHON=python3
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
    python3-dev \
    python3-pip \
    python3-setuptools \
    ca-certificates \
    curl \
    libnccl2=2.4.7-1+cuda10.2 \
    libgomp1 \
    libnccl-dev=2.4.7-1+cuda10.2 \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libpng-dev \
    libzmq3-dev \
    git \
    wget \
    vim \
    build-essential \
    openssh-client \
    openssh-server \
    zlib1g-dev \
    libgtk2.0-dev \