#! bin/bash

curl -O  https://s3-us-west-2.amazonaws.com/aws-efa-installer/aws-efa-installer-1.5.1.tar.gz

tar -xf aws-efa-installer-1.5.1.tar.gz

cd aws-efa-installer

sudo ./efa_installer.sh -y

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin

sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600

sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"

sudo apt-get update

sudo apt-get -y install cuda

NCCL_VERSION=2.5.6-2

wget https://github.com/NVIDIA/nccl/archive/v${NCCL_VERSION}.tar.gz

tar -xf  v${NCCL_VERSION}.tar.gz

cd nccl-${NCCL_VERSION}

make -j src.build

sudo reboot

OPENMPI_VERSION=3.1.4

wget -q -O - https://www.open-mpi.org/software/ompi/v$(echo "${OPENMPI_VERSION}" | cut -d . -f 1-2)/downloads/openmpi-${OPENMPI_VERSION}.tar.gz | tar -xzf -

cd openmpi-${OPENMPI_VERSION}

./configure --enable-orterun-prefix-by-default --with-verbs --prefix=/usr/local/mpi --disable-getpwuid

sudo make -j install

sudo echo "/usr/local/mpi/lib" >> /etc/ld.so.conf.d/openmpi.conf

sudo ldconfig

sudo apt-get install libudev-dev dh-autoreconf

cd

git clone https://github.com/aws/aws-ofi-nccl.git -b aws

cd aws-ofi-nccl

./autogen.sh

NCCL_VERSION=2.5.6-2

./configure --with-libfabric=/opt/amazon/efa/ --with-cuda=/usr/local/cuda --with-nccl=/home/ubuntu/nccl-${NCCL_VERSION}/build --with-mpi=/usr/local/mpi --prefix=/home/ubuntu/aws-ofi-nccl/install

make

make install

cd

ssh-keygen

printf "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null\n" >> ~/.ssh/config
printf "\tLogLevel=ERROR\n\tServerAliveInterval=30\n\tUser ubuntu\n" >> ~/.ssh/config

echo `cat id_rsa.pub` >> authorized_keys

cat /sys/kernel/mm/transparent_hugepage/enabled

nvidia-smi -q |grep Persistence

sudo nvidia-smi -pm ENABLED

sudo nvidia-smi -ac 877,1380

sudo vim /etc/default/grub

# GRUB_CMDLINE_LINUX="spectre_v2=off noibpb pti=off"

cat /sys/devices/system/cpu/vulnerabilities/spec_store_bypass

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/amazon/efa/lib:/usr/local/mpi/lib:/home/ubuntu/nccl/build/lib:/home/ubuntu/aws-ofi-nccl/install/lib

export INCLUDE_PATH=$INCLUDE_PATH:/opt/amazon/efa/include/:/usr/local/mpi/include:/home/ubuntu/nccl/build/include

export PATH=$PATH:/opt/amazon/efa/bin:/usr/local/mpi/bin

source ~/.bashrc

cd

git clone https://github.com/NVIDIA/nccl-tests.git

cd nccl-tests

make MPI=1 MPI_HOME=/usr/local/mpi/ NCCL_HOME=/home/ubuntu/nccl-${NCCL_VERSION}/build

mpirun -x FI_PROVIDER="efa" -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/amazon/efa/lib:/usr/local/mpi/lib:/home/ubuntu/nccl-${NCCL_VERSION}/build/lib:/home/ubuntu/aws-ofi-nccl/install/lib -x NCCL_DEBUG=INFO -H 127.0.0.1:8 /home/ubuntu/nccl-tests/build/all_reduce_perf -b 8 -e 1G -f 2 -c0
