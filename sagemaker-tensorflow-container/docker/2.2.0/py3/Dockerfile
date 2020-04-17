FROM nvcr.io/nvidia/tensorflow:20.02-tf2-py3

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y python3-opencv libopenblas-base \
	libomp-dev build-essential

ENV PATH="/usr/local/nvm/versions/node/v13.7.0/bin:${PATH}"

RUN pip3 install tensorflow==2.2.0-rc2

RUN pip3 install --upgrade tensorflow_addons virtualenv

RUN git clone https://github.com/tensorflow/profiler.git profiler
RUN mkdir profile_env
# RUN python profiler/install_and_run.py --envdir=profile_env --logdir=profiler/demo
    
RUN pip install ipywidgets imgaug addict terminaltables  \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager

RUN pip install jupyterlab-nvdashboard tqdm tensorflow_datasets \
    && jupyter labextension install jupyterlab-nvdashboard

RUN pip install matplotlib scikit-learn scikit-image seaborn \
	cython numba tqdm tensorflow_datasets \
	&& pip install pycocotools

CMD nohup jupyter lab --allow-root --ip=0.0.0.0 --no-browser > notebook.log

