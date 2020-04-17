ARG CUDA_VERSION=10.1
ARG LINUX_VERSION=ubuntu18.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-${LINUX_VERSION}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
ENV DEBIAN_FRONTEND=noninteractive

ARG CC=7
ARG CXX=7
RUN apt update -y --fix-missing && \
    apt upgrade -y && \
      apt install -y \
      git \
      gcc-${CC} \
      g++-${CXX} \
      libnuma-dev \
      tzdata \
      librdmacm-dev libnuma-dev libibverbs-dev \
      locales \
      vim \
      wget

RUN wget https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh
RUN sh Miniconda3-4.7.12.1-Linux-x86_64.sh -b -p /conda
ENV PATH=${PATH}:/conda/bin
SHELL ["/bin/bash", "-c"]
RUN rm Miniconda3-4.7.12.1-Linux-x86_64.sh

RUN apt-get install -y --no-install-recommends libnvinfer6=6.0.1-1+cuda10.1 \
    libnvinfer-dev=6.0.1-1+cuda10.1 \
    libnvinfer-plugin6=6.0.1-1+cuda10.1

ENV CONDA_ENV=rapids
RUN conda create -y --name ${CONDA_ENV} python=3.7 
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/conda/envs/${CONDA_ENV}/lib
RUN source activate ${CONDA_ENV} && conda install -y -c conda-forge cudatoolkit=10.1 cmake>=3.12 numba>=0.45.1 pandas=0.24.2 \
pyarrow=0.15.0 arrow-cpp=0.15.0 fastavro>=0.22.0 dlpack boost boost-cpp double-conversion rapidjson flatbuffers \
dask distributed>=1.23.0 cffi>=1.10.0 cython=0.29 

RUN source activate ${CONDA_ENV} && conda install -y -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.11

RUN source activate ${CONDA_ENV} && conda install -y -c conda-forge lapack openblas dask-ml \
libhwloc libtool pkg-config pytest-asyncio setuptools ipython ipykernel jupyter jupyterlab ipywidgets nodejs \
bokeh python-graphviz scikit-learn matplotlib awscli s3fs pip

RUN source activate ${CONDA_ENV} && conda install -y -c bokeh jupyter_bokeh

RUN source activate ${CONDA_ENV} && pip install tensorflow-gpu tensorflow_datasets jupyterlab-nvdashboard 

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/conda/envs/${CONDA_ENV}/lib
RUN source activate ${CONDA_ENV} && jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
jupyter labextension install @jupyterlab/hub-extension && \
jupyter labextension install @bokeh/jupyter_bokeh && \
jupyter labextension install jupyterlab-nvdashboard

ARG CC=gcc
ARG CXX=g++

RUN source activate ${CONDA_ENV} && pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/weekly/cuda/10.0 nvidia-dali-weekly && \
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/weekly/cuda/10.0 nvidia-dali-tf-plugin-weekly
