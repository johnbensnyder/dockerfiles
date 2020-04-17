ARG RAPIDS_REPO=rapidsai/rapidsai-nightly
ARG RAPIDS_VERSION=0.12
ARG CUDA_VERSION=10.1
ARG CUDA_MAJORMINOR_VERSION=${CUDA_VERSION}
ARG LINUX_VERSION=ubuntu18.04
ARG PYTHON_VERSION=3.6
ARG BASE_IMAGE=${RAPIDS_REPO}:${RAPIDS_VERSION}-cuda${CUDA_VERSION}-base-${LINUX_VERSION}-py${PYTHON_VERSION}

FROM ${BASE_IMAGE}

ARG CUDA_MAJORMINOR_VERSION

# devel environment config args
ARG CC_VERSION=7
ARG CXX_VERSION=7
ARG PARALLEL_LEVEL=8

# devel environment core build pkgs
ARG BOOST_CPP_VERSION=1.70.0
ARG CMAKE_VERSION=3.14.5
ARG LIBGFORTRAN_NG_VERSION=7.3.0
ARG NUMBA_VERSION=0.46
ARG NUMPY_VERSION=1.17
ARG PANDAS_VERSION=0.24.2

# notebook pkgs
ARG IPYTHON_VERSION=7.3*

# base/runtime install specs
ARG DASK_XGBOOST_CONDA_VERSION_SPEC=0.2*
ARG RAPIDS_CONDA_VERSION_SPEC=0.12*

# Install the notebook dependencies and the notebook repo
RUN source activate rapids \
    && env \
    && conda info \
    && conda config --show-sources \
    && conda list --show-channel-urls \
    && ${RAPIDS_DIR}/utils/condaretry install -y -n rapids --freeze-installed \
      bokeh \
      cudatoolkit=${CUDA_MAJORMINOR_VERSION} \
      dask-labextension \
      dask-ml \
      ipython=${IPYTHON_VERSION} \
      jupyterlab \
      matplotlib \
      networkx \
      nodejs \
      pytest \
      scikit-learn \
      scipy \
      seaborn \
      umap-learn \
      ipywidgets \
      tqdm \
      blas=*=openblas \
   && conda clean -afy \
   && chmod -R ugo+w /opt/conda \
   && pip install "git+https://github.com/rapidsai/jupyterlab-nvdashboard.git#master" --upgrade \
   && jupyter labextension install dask-labextension jupyterlab-nvdashboard @jupyter-widgets/jupyterlab-manager \
   && cd ${RAPIDS_DIR} \
   && ./clone.sh notebooks \
   && chmod -R ugo+w /opt/conda ${RAPIDS_DIR}

RUN source activate rapids \
    && pip install tensorflow-gpu tensorflow-datasets \
    && apt update \
    && apt install -y build-essential \
    && conda install -y -c conda-forge openmpi \
    && pip install horovod

# docker run -it --rm -d --gpus all --net=host --name rapids -v ~/data/:/rapids/data -v ~/scripts:/rapids/scripts -v ~/notebooks:/rapids/notebooks johnbensnyder/rapids:0.0.0-a 
