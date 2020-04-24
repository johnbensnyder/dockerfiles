#! /bin/bash

OPENMPI_VERSION=4.0.3

###################################################
# Install openmpi
###################################################

wget -q -O - https://www.open-mpi.org/software/ompi/v$(echo "${OPENMPI_VERSION}" | cut -d . -f 1-2)/downloads/openmpi-${OPENMPI_VERSION}.tar.gz | tar -xzf -

cd openmpi-${OPENMPI_VERSION}

./configure --enable-orterun-prefix-by-default --with-verbs --prefix=/usr/local/mpi --disable-getpwuid

sudo make -j install

sudo /bin/bash -c "echo \"/usr/local/mpi/lib\" >> /etc/ld.so.conf.d/openmpi.conf"

sudo ldconfig
